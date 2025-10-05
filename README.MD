Fork of the Midnight Lizard project.

## Preferences Back-up from a previous installation:

```
(async () => {
    try {
        if (!chrome || !chrome.storage) {
            throw new Error('The chrome.storage API is not available.');
        }

        const getStorageData = (storageArea) => new Promise(resolve => storageArea.get(null, result => resolve(result)));
        
        const syncData = await getStorageData(chrome.storage.sync);
        const localData = await getStorageData(chrome.storage.local);

        const syncJson = JSON.stringify(syncData);
        const localJson = JSON.stringify(localData);

        const restoreScript = `
(async () => {
    try {
        const setStorageData = (storageArea, data) => new Promise(resolve => storageArea.set(data, resolve));
        await setStorageData(chrome.storage.sync, ${syncJson});
        await setStorageData(chrome.storage.local, ${localJson});
        alert('Settings have been restored! Please close and re-open the popup to see the changes.');
    } catch (e) {
        console.error('Error restoring settings:', e);
        alert('An error occurred while restoring. See the console for details.');
    }
})();
        `;
        
        console.log("✅ SUCCESS! The backup script is ready. Copy the text block below (the one inside the quotes) and paste it into a text file.");
        console.log(restoreScript);
        alert('✅ SUCCESS! The backup script has been printed to the console below. Please copy it from there.');

    } catch (e) {
        console.error('Error creating backup:', e);
        alert(`An error occurred during backup: ${e.message}`);
    }
})();
```
Copy the async() output to a textfile.

## To compile the plugin:

- Requires Docker to be running.

```
cd ~/Desktop/Midnight-Lizard-master
chmod +x docker-build.sh
./docker-build.sh
```
