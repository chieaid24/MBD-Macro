# MBD-Macro
- Helper Macro written in AutoHotKey for **MBDVidia**. Supports the _Dimensional Tolerance_ and _Geometric Tolerance_ functions in creating the PMI for 3D models. Increases productivity by streamlining repetitive tasks and allowing the user to use more shortcuts than the software supports. 

________
## How do I deploy it?
After downloading the repo, simply run the MBDMacro.exe file and navigate to MBDVidia. A small logo in the top left of the window means the script is active.  
- **Requirements**: Must run on 1920 x 1080 resolution
- In the _Customize Keyboard_ settings, map **"Create GTol"** to **G** and **"Create DTol"** to **D**
____
## Keyboard Shortcuts:
___
### (D)
- Opens up the _Dimensional Tolerance_ mode
- Activates the respective Macro--its active status represented by the graphic appearing on the left side of the screen
- The _Dimensional Tolerances_ is defaulted to _Feature Size_
    - Use **(Alt + 1)**, **(Alt + 2)**, **(Alt + 3)**, **(Alt + 4)** to access each of the tolerances, respectively
- After clicking on the desired faces to dimension, enter the tolerance into the pop-up and hit **Enter**
    - This will automatically populate both **+** and **-** tolerances and _confirm_
- **Note:** Pressing **D** again or **RMButton** at any point will exit _Dimensional Tolerance_ mode as well as the Macro
### (G)
- Opens up the _Geometric Tolerance_ mode
- Also activates its respective Macro, represented by the graphic on the left of the screen
- Automatically opens up the dropdown menu for the _Geometric Tolerances_
    - After selecting one, click the respective face you wish to tolerance
- Enter tolerance information into the pop-up and then you must manually select the rest of your data
    - Clicking the green checkmark or hitting **Enter** will confirm your tolerance
- **Note:** Pressing **G** again or **RMButton** at any point will exit _Geometric Tolerance_ mode as well as the Macro
### (~)
- When prompted with the _Enter tolerance:_ popup, pressing **~** will quickly dismiss it
    - Allows you to enter non-symmetrical tolerances or other unsupported options
### (Alt + D) or (Alt + G)
- If you wish to bring the popup back up after dismissing it, this will do so
  - **(Alt + D)** If you wish to bring the _Dimensional Tolerance_ popup back
  - **(Alt + G)** If you wish to bring the _Geometric Tolerance_ popup back
### (Alt + E)
- Reset both _Dimensional_ and _Geometric_ Macros if something goes awry
### (Alt + X)
- Force stops the program
___
## Demo Video:
I've posted a YouTube demonstration [here](https://youtu.be/7-iw15DLMDQ) for visual learners!
___
## That's it!
- Hopefully you'll find the program helpful in improving your workflow efficiency!
