# COVIDClicks
## An IOS App for the CoronaDiagnosis Project
##### About the App
1. This app's two goals are to help doctors diagnose COVID-19 and educate people on the effects COVID-19 has on the lungs
2. This App asks users to upload X-Ray Images. The CoreML Model then classifies the image as COVID, NORMAL, or Pneumonia.
3. The Learn View has sample images for each of the categories.

##### About the Project Structure:
1. This App uses a CoreML Model to Diagnose COVID-19 through Lung X-Rays.
2. Within the covidAI folder, there are three view controllers for the Learn View, About View, and Main View.
3. The App uses FeaturePrint Euclidean Distance in order to ensure the make sure the images it is receiving are close to the sample images

![Screenshot](screenshot.jpg)

