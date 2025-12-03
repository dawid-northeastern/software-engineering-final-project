Miah Safoan
Northeastern University London
miah.sa@northeastern.edu


Nico Poulsen
Dawid Szczur
AE2 Individual Project Report:
STEAK MASTER
LCSCI6206 Fundamentals of Software Engineering 2025






Keywords: Serious Game, Generative AI Education, Cooking Skill Training, Interactive Learning


Abstract
SteakMaster is a serious game for mastering the art of steak cooking. Users will be guided through a user-friendly process. Starting from a clear title screen, the app directs you to training modules that cover the must know of: steak cuts, thickness, doneness and cooking methods. **Each module consists of a brief tutorial (slides with key facts and images) followed by a quiz question. Only upon answering the quiz correctly is the module marked complete.**


Once all the modules have been completed, the full assessment mode is unlocked, and you're able to test your skills, with an AI generated judge profile simulating real-world customer preferences. **You choose your cut, thickness, and doneness, then receive an AI analysis of how well you met the judge’s expectations.** An AI also evaluates the choices, returns a numerical score and targeted feedback, and offers culinary tips. The application is developed in Flutter which supports cross platform deployment between devices and uses persistent storage to keep user progress across sessions. SteakMaster demonstrates how serious games, with AI implementation, can provide flexible, somewhat personalized training, making cooking skills accessible to beginners or to those wanting to learn how to cook steaks well.


3 Design and Implement


The application is built in Flutter using a screen based structure where each major part of the app is implemented as its own widget, such as HomeScreen, ModulesScreen, and ModuleScreen. Information is stored in simple classes; ModuleInfo, Judge, and FeedbackResult, keeping the UI separate from data and behaviour. Helper functions such as the OpenAI API requests manage functions such as slide navigation and AI requests. Navigation follows the standard Navigator.push pattern. **Each module is tracked via its completion state using the ProgressManager, and a Continue button appears once all modules are successfully completed.** Persistent storage using SharedPreferences is used to remember whether modules have been completed.


**Users may save and load their progress at any time. This is handled via persistent storage (SharedPreferences); for example, the current judge round and which modules are completed can be saved and later restored, allowing the training to be resumed without starting over. A reset option is also provided, allowing players to restart the entire game from scratch if desired.**


Use of Asynchronous Programming
The design uses async/await for network requests; asynchronous operations allow the program to continue executing while waiting for the operation to finish, preventing the app from freezing while the app communicates with the AI service.




State Management
The final version of the application uses a ProgressManager class to manage global game state; module completion, saved progress, and assessment resets, this gives consistent behaviour between all the screens and allows the app to restore user progress using SharedPreferences, rather than relying only on local states. This addition of the global state makes it more reliable and easier to extend. **The game evaluates overall performance using the accumulated XP and error count. Only if the player has gained sufficient XP with few mistakes does the ending declare success; otherwise, the ending encourages further training.**


Justification of Architecture
This architecture also supports the learning goals of the serious game as research claims that serious games are most effective when they incorporate “feedback, practice, and opportunities to apply knowledge in varied contexts” (Clark et al., 2016, p. 4). By separating learning modules from assessment scenarios (application), and letting the AI provide personalised feedback, the architecture directly mirrors these evidence based principles.


3.4 AI Service
A big part of my contribution to the project was implementing the AI service, which allowed the application to generate judge profiles and personalised feedback using openAI API calls, this feature turns the assessment phase from a static sequence into dynamic. Monib et al. (2024) notes, “Generative AI has the potential to provide personalised, context-aware guidance in learning environments.”


The AI logic is fully contained in ai_service.dart, keeping networking separate from the rest of the code; two asynchronous functions handle communication with the external system:
getJudge: **Returns a structured personality and preference description to enhance immersion.**
getFeedback: Evaluates the player’s decisions and returns a score, a short reasoning, and a tip for improvement, using a similar JSON structure.


**The judge’s analysis is powered by a generative AI (via the OpenAI API), which evaluates the player's chosen parameters against the judge’s preferences.** After submitting your choices, the judge’s feedback is displayed in-app as a pop-up panel. **It provides a numerical score (0–100), the judge’s thoughts on your choices, specific feedback comments, and a tip for improvement.**


**As each selection is made, the game instantly indicates whether it matches the judge’s preference (granting experience points or noting an error) via a brief on-screen notification. This immediate feedback reinforces learning in real-time, even before the AI’s full critique is shown.**


**Instead of random AI-generated judges each time, we defined a set of three distinct judge personas (Adam, Amanda, Lucas) with varying levels and preferences. This provides a consistent progression in difficulty and allows the AI to focus on generating personalized feedback for the player’s choices.**


To make sure that the AI components worked correctly before the assessment screens were implemented, I created a small console program test_ai.dart, that directly calls getJudge and getFeedback, allowing me to verify that the API responses were valid JSON, that they matched the structure needed making debugging a lot easier. Placeholder values were added for the judge and feedback to allow teammates to continue building their screens while the API code was still being finalised.


**To enhance immersion, the app plays subtle background jazz music on the title and main screens. This audio loop helps set a relaxed, cooking-themed atmosphere for the user.**


**An animated transition plays as the steak is ‘served’ to the judge – a plate slides in with steaming effects – before the feedback panel appears. This small animation adds visual reward and connects the gameplay to the cooking theme.**


**The interface is visually themed: for example, the home screen features a grill background with a smoky overlay, and all screens use warm brown tones to reinforce the steakhouse atmosphere.**