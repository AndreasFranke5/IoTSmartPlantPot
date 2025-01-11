/* eslint-disable indent */
const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');
const { getMessaging } = require('firebase-admin');
const { get, orderByChild, query } = require('firebase-admin/database');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

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
    const users = (
      await admin.database().ref(`plantSlotUsers/${slotId}`).once('value')
    ).val();
    if (users) {
      const userIds = Object.values(users);

      // send notifications
      for (let j = 0; j < userIds.length; j++) {
        const userId = userIds[j];

        const notificationToken = (
          await admin
            .database()
            .ref(`users/${userId}/notificationToken`)
            .once('value')
        ).val();

        if (notificationToken) {
          const notificationData = {
            data: {
              title: 'Plant Update',
              body: `Slot ${slotId} has been updated`,
            },
            token: notificationToken,
          };
          admin.messaging().send(notificationData);
        }
      }
    }

    response.status(200).send('Data added successfully');
  } catch (error) {
    console.error('Error sendPlantUpdates:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getPredefinedPlants = onRequest(async (request, response) => {
  try {
    // const bearer = request.headers.authorization;

    // if (!bearer) {
    //   response.status(400).send('User not authenticated');
    //   return;
    // }
    // const idToken = bearer.split('Bearer ')[1];
    // // Verify the ID token
    // const decodedToken = await admin.auth().verifyIdToken(idToken);
    // if (!decodedToken) {
    //   response.status(400).send('User not authenticated');
    //   return;
    // }

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
