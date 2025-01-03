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
    const { uid } = decodedToken;
    const { deviceId } = request.body;

    if (!uid || !deviceId) {
      response.status(400).send('Invalid');
      return;
    }

    const userDeviceRef = admin
      .database()
      .ref(`users/${uid}/devices/${deviceId}`);
    await userDeviceRef.set({ deviceId, addedOn: new Date().valueOf() });

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
    const { uid } = decodedToken;

    const { deviceId, plantId, name } = request.body;

    if (!uid || !deviceId || !plantId) {
      response.status(400).send('Invalid');
      return;
    }

    // TODO: get the plant image from the predefined list
    const plantImage = 'https://example.com/plant-image.jpg';

    const userDeviceRef = admin
      .database()
      .ref(`users/${uid}/devices/${deviceId}/plants/${plantId}`);
    await userDeviceRef.set({
      deviceId,
      plantId,
      name,
      image: plantImage,
      addedOn: new Date().valueOf(),
    });

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
    const { uid } = decodedToken;

    const userDevicesRef = admin.database().ref(`users/${uid}/devices`);
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
    const { uid } = decodedToken;

    const userDevicesRef = admin.database().ref(`users/${uid}/devices`);
    if (!userDevicesRef) {
      response.status(404).send('No devices found');
    }

    userDevicesRef.once('value', async (snapshot) => {
      const plantsList = [];
      snapshot.forEach((device) => {
        const { plants } = device.val();
        if (!plants) {
          return;
        }
        Object.values(plants).forEach((plant) => {
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
    const { uid } = decodedToken;

    const userPlantsRef = admin.database().ref(`users/${uid}`);
    if (!userPlantsRef) {
      response.status(404).send('User found');
    }

    userPlantsRef.once('value', async (snapshot) => {
      response.json(snapshot.val());
    });
  } catch (error) {
    console.error('Error getUserPlants:', error);
    response.status(500).send('Internal Server Error');
  }
});
