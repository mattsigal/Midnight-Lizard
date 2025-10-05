Fork of the Midnight Lizard project.

## To back-up preferences from a previous installation:

1. On a machine with your original, configured Midnight Lizard, open its popup, right-click inside, and select "Inspect."
2. Go to the "Console" tab.
3. Paste and run the following:

```
(async () => {
    try {
        if (!chrome || !chrome.storage) { throw new Error('Storage API not found.'); }
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
        alert('Settings have been restored!');
    } catch (e) { console.error('Error restoring settings:', e); }
})();`;
        console.log("✅ SUCCESS! Copy the entire text block below (starting with '(async () =>') and save it to a text file.");
        console.log(restoreScript);
    } catch (e) { console.error('Error creating backup:', e); }
})();
```
4. Copy the async() output to a textfile.

## To compile the plugin:

1. Download the source code from the GitHub repo and unzip it.
2. Run the following:

```
cd ~/Desktop/Midnight-Lizard-master
chmod +x docker-build.sh
./docker-build.sh
```
3. When it finishes, there should be a releases/dist folder containing the compiled extension.

## Re-Install Extension
1. Use Developer Mode to install extension from the "Load unpacked" dialogue box.
2. Select the dist folder located inside the releases folder.
3. Import preferences by copying the entire textfile and pasting it in the Console view for the extension preferences.
4. Finally run the following to copy the preferences from sync storage to local storage:
```
(async () => {
    try {
        console.log("Reading all settings from sync storage...");
        const syncSettings = await new Promise(resolve => {
            chrome.storage.sync.get(null, resolve);
        });
        if (Object.keys(syncSettings).length === 0) {
            alert("Sync storage is empty. Nothing to copy.");
            return;
        }
        console.log("Found settings! Writing them to local storage...");
        await new Promise(resolve => {
            chrome.storage.local.set(syncSettings, resolve);
        });
        alert('✅ Success! Settings have been copied over. Close and re-open the popup to see your changes.');
    } catch (e) {
        console.error('An error occurred during the copy:', e);
    }
})();
```
5. Restart Brave to see the changes!
