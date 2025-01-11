/* eslint-disable indent */
const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

// add device to the user from the key retrieved from the QR code
exports.addDevice = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;
    const { deviceId, name } = request.body;

    if (!idToken || !deviceId || !name) {
      response.status(400).send('Invalid');
      return;
    }

    const existingUser = await admin.auth().getUserByEmail(email);

    const predefinedDevice = await admin
      .database()
      .ref(`devices/${deviceId}`)
      .once('value');

    if (!predefinedDevice) {
      response.status(404).send('Device not found');
      return;
    }

    const userDeviceRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices/${deviceId}`);
    await userDeviceRef.set({
      deviceId,
      name,
      addedOn: new Date().valueOf(),
    });

    const userPlantSlots = admin
      .database()
      .ref(`users/${existingUser.uid}/devices/${deviceId}/slots`);

    predefinedDevice.val()?.slots.forEach(async (slot) => {
      await userPlantSlots
        .child(slot)
        .set({ id: slot, deviceId, status: 'empty' });
    });

    response.status(200).send('Device added successfully');
  } catch (error) {
    console.error('Error addDevice:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.addNewPlant = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const { deviceId, slotId, plantId, name } = request.body;

    if (!idToken || !deviceId || !slotId || !plantId) {
      response.status(400).send('Invalid');
      return;
    }

    const existingUser = await admin.auth().getUserByEmail(email);
    const userDeviceRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices/${deviceId}/slots/${slotId}`);

    const predefinedPlantRef = await admin
      .database()
      .ref(`plants/${plantId}`)
      .once('value');

    await userDeviceRef.set({
      deviceId,
      id: slotId,
      plantId,
      name,
      image: predefinedPlantRef.val()?.image,
      addedOn: new Date().valueOf(),
      status: 'data',
    });

    // add plantSlot-users data
    const plantUsersRef = admin.database().ref(`plantSlotUsers/${slotId}`);
    plantUsersRef.push(existingUser.uid);

    response.status(200).send('Plant added successfully');
  } catch (error) {
    console.error('Error addDevice:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getUserDevices = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userDevicesRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices`);
    if (!userDevicesRef) {
      response.status(404).send('No devices found');
    }

    userDevicesRef.once('value', async (snapshot) => {
      const devicesList = [];
      snapshot.forEach((plant) => {
        devicesList.push(plant.val());
      });
      response.json(devicesList);
    });
  } catch (error) {
    console.error('Error getUserDevices:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getUserPlants = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userDevicesRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices`);
    if (!userDevicesRef) {
      response.status(404).send('No devices found');
    }

    userDevicesRef.once('value', async (snapshot) => {
      const plantsList = [];
      snapshot.forEach((device) => {
        const { slots } = device.val();
        if (!slots) return;

        Object.values(slots).forEach((plant) => {
          plantsList.push(plant);
        });
      });
      response.json(plantsList);
    });
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getUserPlantsStats = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userDevicesRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices`);

    if (!userDevicesRef) {
      return response.status(200).json([]);
    }

    const snapshot = await userDevicesRef.once('value');

    if (!snapshot.exists()) return response.status(200).json([]);

    const slotsList = [];

    for (let i = 0; i < Object.values(snapshot.val()).length; i++) {
      const { slots } = Object.values(snapshot.val())[i];

      console.log('slots:', slots);

      if (!slots) return response.status(200).json([]);

      for (let index = 0; index < Object.values(slots).length; index++) {
        const slot = Object.values(slots)[index];
        const plantDataRef = admin
          .database()
          .ref(`plantsData/${slot.id}`)
          .orderByChild('createdAt')
          .limitToLast(1);

        const slotData = await plantDataRef.once('value');
        if (slotData.exists()) slotsList.push(slotData.val());
      }

      const list = slotsList.map((item) => Object.values(item)[0]);
      return response.status(200).json(list);
    }

    return response.status(200).json([]);
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getPlantSlotDetails = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const { email } = await admin.auth().verifyIdToken(idToken);
    const { slotId } = request.query;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userDevicesRef = admin
      .database()
      .ref(`users/${existingUser.uid}/devices`);
    if (!userDevicesRef) {
      return response.status(404).send('Invalid slot id');
    }

    const devices = (await userDevicesRef.once('value')).val();

    if (!devices) return response.status(404).send('Invalid slot id');

    for (let i = 0; i < Object.values(devices).length; i++) {
      const { slots } = Object.values(devices)[i];

      for (let j = 0; j < Object.values(slots).length; j++) {
        const slot = Object.values(slots)[j];
        if (slot.id === slotId && slot.status !== 'empty') {
          const preDefPlant = (
            await admin.database().ref(`plants/${slot.plantId}`).once('value')
          ).val();

          const plantSlotDetails = {
            ...slot,
            ...preDefPlant,
            id: slot.id,
          };
          return response.status(200).json(plantSlotDetails);
        }
      }
    }

    return response.status(400).send('Plant slot not found');
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.getUser = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userPlantsRef = admin.database().ref(`users/${existingUser.uid}`);
    if (!userPlantsRef) {
      response.status(404).send('User not found');
    }

    userPlantsRef.once('value', (snapshot) =>
      snapshot.exists()
        ? response.status(200).json(snapshot.val())
        : response.status(404).send('User found')
    );
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});

exports.assignNotificationToken = onRequest(async (request, response) => {
  try {
    const bearer = request.headers.authorization;
    const { token } = request.body;

    if (!bearer) {
      response.status(400).send('User not authenticated');
      return;
    }
    const idToken = bearer.split('Bearer ')[1];
    // Verify the ID token
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const { email } = decodedToken;

    const existingUser = await admin.auth().getUserByEmail(email);
    const userPlantsRef = admin
      .database()
      .ref(`users/${existingUser.uid}/notificationToken`);
    if (!userPlantsRef) {
      response.status(404).send('User not found');
    }

    await userPlantsRef.set(token);
    response.status(201).send('Notification token added successfully');
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});
