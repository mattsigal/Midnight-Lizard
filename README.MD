Fork of the Midnight Lizard project.

## To back-up preferences from a previous installation or to transfer preferences to a different device:

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

        // Restore sync and local data to their proper places
        console.log("Restoring settings to sync storage...");
        await setStorageData(chrome.storage.sync, ${syncJson});

        console.log("Restoring settings to local storage...");
        await setStorageData(chrome.storage.local, ${localJson});

        alert('✅ Success! Settings restored to sync and local storage.');
        console.log("✅ Restore complete!");

    } catch (e) {
        console.error('An error occurred during restore:', e);
        alert('An error occurred. Check the console for details.');
    }
})();`;

        console.log("✅ SUCCESS! Copy the entire text block below and save it to your text file.");
        console.log(restoreScript);

    } catch (e) {
        console.error('Error creating backup:', e);
        alert('An error occurred during backup. Check the console for details.');
    }
})();
```
4. Copy the async() output to a textfile.

## To compile the plugin:

1. Download the source code from the GitHub repo and unzip it.
2. Run the following:

```
cd ~/Desktop/Midnight-Lizard-master
docker build -t midnight-lizard .
docker create --name extractor midnight-lizard
docker cp extractor:/build/ ./MidnightLizard/
docker rm extractor
```
3. When it finishes, there should be a MidnightLizard subfolder containing the compiled extension.

## Re-Install Extension
1. Copy the MidnightLizard folder to a folder for your web browser to access.
2. Use Developer Mode to install the extension from the "Load unpacked" dialogue box.
3. To import the saved preferences, open the Midnight Lizard settings box and go to the Console view. Paste the entire textfile from Step 4 into the console.
4. Restart Brave to see the changes!

## Moving Midnight Lizard to Other Devices

Since this is compiled locally, it will not sync automatically to other devices. To manually sync the plug-in and it's preferences:
1. Find the compiled MidnightLizard directory and the saved preferences text file and place them somewhere the other devices access (e.g., OneDrive folder). 
2. On the other machines, install the plug-in via Developer mode.
3. Use the code from the backup textfile to restore preferences.
4. [OPTIONAL]: Run the following in the same console window to check that the restore worked (both the local and sync storage containers should be populated with your preferences):

```
(async () => {
    const syncSettings = await new Promise(resolve => chrome.storage.sync.get(null, resolve));
    const localSettings = await new Promise(resolve => chrome.storage.local.get(null, resolve));
    
    console.log("Sync Storage Content:", syncSettings);
    console.log("Local Storage Content:", localSettings);
})();
```
