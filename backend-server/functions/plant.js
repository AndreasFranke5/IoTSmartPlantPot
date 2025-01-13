/* eslint-disable indent */
const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

/// send plant updates from the raspberry pi
/// {
///   "deviceId": "device1",
///   "slotId": "slot1",
///   "temperature": 25,
///   "moisture": 50,
///   "uv": 0.5,
///   "lux": 1000
/// }
exports.sendPlantUpdates = onRequest(async (request, response) => {
  try {
    const { deviceId, slotId, temperature, moisture, uv, lux } = request.body;

    const createdAt = new Date().valueOf();
    const data = {
      deviceId,
      slotId,
      temperature,
      moisture,
      uv,
      lux,
      createdAt,
    };

    await admin.database().ref(`plantsData/${slotId}/${createdAt}`).set(data);

    // send notification to the user
    const plantSlotRef = admin.database().ref(`plantSlotUsers/${slotId}`);
    const plantSlot = await plantSlotRef.once('value');
    const users = plantSlot.val();

    if (users) {
      const userIds = Object.keys(users);

      // send notifications
      for (let j = 0; j < userIds.length; j++) {
        const userId = userIds[j];

        // last watering notification time
        const lastWatered = await admin
          .database()
          .ref(`plantSlotUsers/${slotId}/${userId}/lastWateredAt`)
          .once('value');

        // last user action notification time
        const lastUserAction = await admin
          .database()
          .ref(`plantSlotUsers/${slotId}/${userId}/lastUserActionAt`)
          .once('value');

        const userRef = admin.database().ref(`users/${userId}`);
        const notificationToken = (
          await userRef.child('notificationToken').once('value')
        ).val();

        const userPlantData = (
          await userRef
            .child(`devices/${deviceId}/slots/${slotId}`)
            .once('value')
        ).val();

        const startWatering =
          ((userPlantData.watering == 'Minimum' && moisture < 30) ||
            (userPlantData.watering == 'Average' && moisture < 50) ||
            (userPlantData.watering == 'Frequent' && moisture < 70)) &&
          (!lastWatered || lastWatered.val() < createdAt - 1000 * 60 * 15);

        let userAction;
        if (userPlantData.sunlight.includes('Full sun') && lux < 100) {
          userAction = 'needs to be moved to a place with more light.';
        }

        console.log('userAction:', userAction);

        if (notificationToken) {
          if (startWatering) {
            const notificationData = {
              data: {
                title: 'Plant watered',
                body: `Plant ${userPlantData.name} has been watered.`,
                intId: '1',
              },
              token: notificationToken,
            };
            console.log('[Notification] sent:', notificationData);

            await admin.messaging().send(notificationData);

            await admin
              .database()
              .ref(`plantSlotUsers/${slotId}/${userId}/lastWateredAt`)
              .set(createdAt);
          }

          if (
            !lastUserAction ||
            lastUserAction.val() < createdAt - 1000 * 60 * 15
          ) {
            if (userAction) {
              const notificationData = {
                data: {
                  title: 'User action required',
                  body: `Plant ${userPlantData.name} ${userAction}`,
                  intId: '2',
                },
                token: notificationToken,
              };
              console.log('[Notification] sent:', notificationData);

              await admin.messaging().send(notificationData);

              await admin
                .database()
                .ref(`plantSlotUsers/${slotId}/${userId}/lastUserActionAt`)
                .set(createdAt);
            }
          }
        }
        return response
          .status(200)
          .json({ success: true, startPump: startWatering });
      }
    }

    response.status(200).json({ success: true });
  } catch (error) {
    console.error('Error sendPlantUpdates:', error);
    response.status(500).send('Internal Server Error');
  }
});

// get predefined plants
exports.getPredefinedPlants = onRequest(async (request, response) => {
  try {
    const { search } = request.query;

    let query = admin
      .database()
      .ref(`plants`)
      .orderByChild('common_name')
      .limitToFirst(10);

    if (search) {
      query = query
        .startAt(search?.toLowerCase())
        .endAt(search?.toLowerCase() + '\uf8ff'); // "\uf8ff" ensures results start with the prefix
    }
    const snapshot = await query.once('value');

    if (snapshot.exists()) {
      const plants = snapshot.val();
      return response.status(200).json(
        Object.keys(plants).map((key) => ({
          id: key,
          ...plants[key],
        }))
      );
    }
    return response.status(200).json([]);
  } catch (error) {
    console.error('Error sendPlantUpdates:', error);
    response.status(500).send('Internal Server Error');
  }
});
