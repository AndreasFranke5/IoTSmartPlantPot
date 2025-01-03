/* eslint-disable indent */
const { onRequest } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.sendPlantUpdates = onRequest(async (request, response) => {
  try {
    const { deviceId, plantId, temperature, moisture } = request.body;

    const data = {
      plantId,
      deviceId,
      temperature,
      moisture,
      createdAt: new Date().valueOf(),
    };

    await admin.database().ref(`plantsData`).push(data);

    // notify user
    // TODO: send notification to the user if needed
    // const users = await admin.database().ref(`users/${deviceId}`).once('value');

    response.status(200).send('Data added successfully');
  } catch (error) {
    console.error('Error sendPlantUpdates:', error);
    response.status(500).send('Internal Server Error');
  }
});

// TODO: listen to plant data changes and notify the user if needed
exports.getPlantData = onRequest(async (request, response) => {});

exports.getPredefinedPlants = onRequest((request, response) => {
  response.json({
    data: [
      { id: 1, name: 'plant type 1' },
      { id: 2, name: 'plant type 2' },
      { id: 3, name: 'plant type 3' },
      { id: 4, name: 'plant type 4' },
      { id: 5, name: 'plant type 5' },
    ],
  });
});
