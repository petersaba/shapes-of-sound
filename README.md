<img src="./readme/title1.svg"/>

<div align="center">

> The Shapes Of Sound app is designed to turn speech into sign language.

**[PROJECT PHILOSOPHY](https://github.com/petersaba/shapes-of-sound#-project-philosophy) • [PROTOTYPING](https://github.com/petersaba/shapes-of-sound#-wireframes) • [TECH STACK](https://github.com/petersaba/shapes-of-sound#-tech-stack) • [IMPLEMENTATION](https://github.com/petersaba/shapes-of-sound#-impplementation) • [HOW TO RUN?](https://github.com/petersaba/shapes-of-sound#-how-to-run)**

</div>

<br><br>


<img src="./readme/title2.svg"/>

> The Shapes Of Sound is utility app built to help people communicate with each other using sign language as well as understand sign language.
>
> The Shapes Of Sound app can also help people to learn sign language.

### User Stories
- As a user, I want to convert my speech to sign language, so that I can communicate with people
- As a user, I want to convert other people's speech to sign language, so that I can communicate with people
- As a user, I want to convert my speech to sign language, so that I can learn sign language

<br><br>

<img src="./readme/title3.svg"/>

> This design was planned before on paper, then moved to Figma app for the fine details.
Note that i didn't use any styling library or theme, all from scratch and using pure css modules

<br>
<b>WIREFRAMES</b>
<br><br>

| Login  | Sign Up  |  Edit Profile  | Home  |
| -----------------| -----| -----------------| -----|
| ![Login](readme/log_in_wireframe.svg) | ![SignUp](readme/sign_up_wireframe.svg) | ![EditProfile](readme/profile_wireframe.svg) | ![Home](readme/homepage_wireframe.svg) |

| Landing div Layout 1  | Landing div Layout 2  |
| --- | --- |
| ![LandingPage1](readme/landing_page_wireframe1.svg) | ![LandingPage2](readme/landing_page_wireframe2.svg) |


<br>

<b>MOCKUPS</b>
<br><br>

| Login  | Sign Up  | Edit Profile  | Home  |
| -----------------| -----|-----------------| -----|
| ![Login](readme/log_in.svg) | ![SignUp](readme/sign_up.svg) | ![EditProfile](readme/profile.svg) | ![Home](readme/homepage.svg) |

| Landing div 1 | Landing div 2 | Landing div 3 |
| --- | --- | --- |
| ![landing_page1](readme/landing_page1.svg) | ![landing_page2](readme/landing_page2.svg) | ![landing_page3](readme/landing_page3.svg) |


<br><br>

<img src="./readme/title4.svg"/>

Here's a brief high-level overview of the tech stack the Well app uses:

- This project uses the [Flutter app development framework](https://flutter.dev/). Flutter is a cross-platform hybrid app development platform which allows us to use a single codebase for apps on mobile, desktop, and the web.
- In order to build the speech recognition model, the app uses [TensorFlow](https://www.tensorflow.org/learn) along with [Keras](https://keras.io/api/) to build the transformer neural network. [TensorFlow](https://www.tensorflow.org/learn) is an open-source library developed by Google primarily for deep learning applications. It also supports traditional machine learning. [Keras](https://keras.io/api/) is an open-source software library that provides a Python interface for artificial neural networks. Keras acts as an interface for the TensorFlow library.
- This project uses the [Laravel](https://laravel.com/docs/9.x) for the backend. Laravel is a cross-platform PHP framework for building web applications. It's a server-based platform that manages data using the Model-View-Controller (MVC) design pattern, dividing an application's backend architecture into logical pieces.
- For persistent storage (database), the app uses the [MySQL](https://www.mysql.com/) relational database management system that is based on Structured Query Language(SQL).
- The implemented speech recognition model is currently trained on the [LJSpeech](https://keithito.com/LJ-Speech-Dataset/) dataset. Due to the required time needed to train full functional speech recognition model, Shapes Of Sound is currently using [AssemblAi's](https://www.assemblyai.com/) speech recognition API until the implemented model is fully trained.


<br><br>
<img src="./readme/title5.svg"/>

> Using the above mentioned tech stacks and the wireframes build with figma from the user sotries we have, the implementation of the app is shown as below, these are screenshots from the real app

| Login  | Sign Up  | Edit Profile  | Home  |
| -----------------| -----|-----------------| -----|
| ![Login](readme/log_in_implementation.jpg) | ![SignUp](readme/sign_up_implementation.jpg) | ![EditProfile](readme/edit_profile_implementation.jpg) | ![Home](readme/homepage_implementation.jpg) |



 --- 
<img src='readme/implementation.gif' width='30%'/>


<br><br>
<img src="./readme/title6.svg"/>


> This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

### Prerequisites
* Install [Flutter](https://docs.flutter.dev/get-started/install) for mobile development.
* Install [XAMPP](https://www.apachefriends.org/download.html) for mySQL server.
* Install [Laravel](https://laravel.com/docs/4.2) for the backend.
* Get API token by creating an account at [AssemblyAi](https://www.assemblyai.com/).


### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/petersaba/shapes-of-sound.git
   ```
2. Install Flutter dependencies
   ```sh
   flutter pub get
   ```
3. Create .env file in './frontend/assets/'
   ```sh
   ASSEMBLYAI_TOKEN = 'your_assemblyai_token'
   ```
4. Rename .env.example to .env in './backend/' and add mySQL information
   ```
   DB_DATABASE=desired_db_name
   DB_USERNAME=your_username
   DB_PASSWORD=your_password
   ```

5. Install necessary dependencies
   ```
   composer install
   ```

6. Run database migrations
   ```
   php artisan migrate
   ```
7. Run mySQL server using XAMPP
8. Run Laravel server
   ```
   php artisan serve
   ```
9. Run Flutter app
   ```
   flutter run
   ```