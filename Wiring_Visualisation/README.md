
# Wiring Visualisation

Very straightforward and easy to use, detailed tutorial on usage below.

**Step 1:**
Open `RobloxStudio`, login and just make an empty baseplate game. Then create a new `Script` instance inside of `ServerScriptService` or anywhere else where scripts can be ran.

**Step 2:** (Optional if you have the Buildverse plugin to import builds manually)
Go to the right upper corner of RobloxStudio, click the `FILE` tab, then open `Game Settings`, you may need to publish your game to access it. Then enable `Allow HTTP Requests` in the security tab.<img width="1003" height="672" alt="Screenshot 2025-09-16 at 7 01 50 PM" src="https://github.com/user-attachments/assets/872a8dac-d869-4793-a2f6-a6947e110d7a" />
(This is only needed if you don't want to import your builds manually via the Buildverse plugin into workspace and then running the script, enabling this allows the script to directly import from Buildverse's API)

**Step 3:**
Paste the code from [here](https://github.com/Fantastic-Fanta/The-Fantastic-Town-API/blob/main/Wiring_Visualisation/Visualiser.lua) into the `Script` you created, edit the config option at the very top with your own code aquired from clicking `Shift+P` on your build **while in part mode** (Enabled with `Shift+T)
<img width="794" height="624" alt="Screenshot 2025-09-16 at 7 20 30 PM" src="https://github.com/user-attachments/assets/166cc943-a216-42f7-98c2-19e8d691f023" />

**Step 4:**
This should generate a 4 character code, in my case it would be `FUQJ`, enter this into the local variable called `ImportCode` inside the configs

<img width="422" height="50" alt="Screenshot 2025-09-16 at 7 22 19 PM" src="https://github.com/user-attachments/assets/ea14a1c4-b26d-4b36-a99e-9c434861d547" />

**Step 5:**
Click `F8` or `Run` inside the testing tab in Studio, make sure to locate your model through selecting and clicking F.
<img width="1260" height="665" alt="Screenshot 2025-09-16 at 7 06 06 PM" src="https://github.com/user-attachments/assets/3e06c402-1830-4ea7-83ee-5a339b134a11" />
