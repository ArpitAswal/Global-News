<p>Click on the GlobalNews logo to download the latest version of app apk file:<p> 
  
  <a href="https://github.com/ArpitAswal/Global-News/releases/download/1.0.0/GlobalNews.apk"> ![ic_launcher](https://github.com/user-attachments/assets/114d981d-013a-41ea-b7cd-a112c691e804)</a>

## Project Title: Global News 

Description: Global News is a dynamic mobile application built using Flutter and Dart, designed to keep users informed with up-to-date global news articles. The app fetches news articles using an API and displays them based on the user's location and preferences. With a focus on user-friendly design and seamless experience, Global News ensures that users have easy access to the latest news from around the world. The app features a splash screen that transitions smoothly into the Home screen, where users are presented with top headlines and other news stories based on their country, automatically determined by the device location.
## Features

Splash Screen: A splash screen is displayed upon launching the app, enhancing the user interface experience.

Top Headlines: Stay informed with top headlines from around the globe.

Country & Category Selection: Filter news based on country or category, including technology, business, health, sports, and more.

Search Functionality: Easily find articles by keywords.

Lazy Loading: News articles load as you scroll, optimizing performance and speed.

Refresh Capability: Quickly refresh content to view the latest updates.

Voice Text Feature: For added accessibility, the NewsDetail screen includes a voice text feature.

Gemini AI Chatbox: The app introduces the Gemini AI Chatbox, powered by the Gemini-1.5-flash model. Available on nearly every screen, this AI assistant allows users to ask questions and receive informative responses with up to 80-90% accuracy, though without creative interpretations or confidential information. 

Smooth User Interface: Designed for a seamless, user-friendly experience with a focus on readability and easy navigation.


## Installation

To run this project locally:

Clone the repository:
git clone https://github.com/ArpitAswal/Global-News.git

Navigate to the project directory:
cd Global-News

Install dependencies: flutter pub get

Set up API Key:

Obtain an API key from News API.

In the project directory, create a new file named lib/config.dart.

Add the following code, replacing 'YOUR_API_KEY' with your News API key:

class Config {
    static const String apiKey = 'YOUR_API_KEY';
}
    
## Note

. Users must grant location permission for the app to function, as it uses, the device's location to fetch news data.

. Users may need to refresh the screen after allowing location access from the settings for the first time.

. The API may not provide, perfectly accurate data, as it does not support fetching articles solely by country. This is particularly relevant for top headlines. For more information about the API, visit News API: "https://newsapi.org/"
## Tech Stack

Flutter: The primary framework for building the mobile application.

Dart: The programming language used with Flutter.

News API: For, fetching global news articles.

Gemini API: To get the response of user prompt by AI assistant


## Challenges

Location Permissions: Ensuring user privacy while handling location-based news.

API Limitations: Managing API rate limits for a smooth, continuous experience.
## Future Enhancements

In future releases, Global News will include several new features to enhance customization and personalization:

Advanced Filtering: Users will be able to filter the news list by date ranges, allowing them to view articles published within specific periods (e.g., X to Y date). Additional sorting options will include relevance, popularity, and publication date, giving users more control over how they view news stories.

User Account and Saved Articles: The app will offer user account profiles where they can manage their information and preferences. Within their profile, users will have access to a Favorites Section to save or like articles they want to revisit. This feature will allow users to save articles directly from the NewsDetail screen, creating a personalized library of favourite content.

Sign-In and Sign-Out: The addition of sign-in and sign-out options will support the Favorites Section, allowing users to maintain their saved articles across devices and sessions.
## Contributing

Contributions are always welcome!

Please follow these steps:

Fork the repository.

Create a new branch (git checkout -b feature-branch).

Make your changes and commit them (git commit -m 'Add new feature').

Push the changes to your fork (git push origin feature-branch).

Create a pull request.

## Usage Flow:
The user opens the Global News app.

The splash screen is displayed.
![Screenshot_2024-08-09-22-32-44-247_com example global_news](https://github.com/user-attachments/assets/1c379a4e-6b87-4dde-a0b1-c47f642f8e26)

The user is taken to the home screen, where top headlines and other news articles are displayed based on the default country but before that it will display a shimmer effect until data is fetched.
![Screenshot_2024-11-03-20-17-06-901_com example global_news](https://github.com/user-attachments/assets/66e35de1-8cb9-48b1-847b-487030c97bf2)

this image shows the different scenarios while displaying the data list
![InCollage_20241104_135019455](https://github.com/user-attachments/assets/5b26dd73-58dd-4c29-af85-ca3258205df6)
![InCollage_20241104_135141970](https://github.com/user-attachments/assets/6fe558cb-083c-40b6-a1f8-1c78ffb67e75)

The user can search for specific articles using the search feature.
![Screenshot_2024-11-03-20-17-13-615_com example global_news](https://github.com/user-attachments/assets/89041446-c5c4-4a1f-ae66-d54450d6189c)
![Screenshot_2024-11-04-18-24-43-060_com example global_news](https://github.com/user-attachments/assets/84d9309b-bdac-4163-9c17-9902bff8286a)

The user can select a different country to view news articles specific to that location.
![Screenshot_2024-11-03-19-50-27-539_com example global_news](https://github.com/user-attachments/assets/dc7192a8-6995-4d5a-900f-23c917746e5c)

The user can navigate to the categories screen to view articles by category.
![Screenshot_2024-11-04-00-06-30-889_com example global_news](https://github.com/user-attachments/assets/855eb9cb-d030-44a1-842b-f104a1799c97)

The user can see more details about the article by clicking on the individual article and even in detail screen user can see more about an article from the browser by clicking on the site URL.
![Screenshot_2024-08-09-22-33-57-182_com example global_news](https://github.com/user-attachments/assets/a005b1e9-8561-4f6b-aa11-87dba7ed3556)
![Screenshot_2024-11-04-18-25-00-082_com example global_news](https://github.com/user-attachments/assets/f458004e-4de7-47a4-a2ea-d3d7ac632565)

Here is the Gemini AI chat box screen-
![Screenshot_2024-11-04-11-17-58-139_com example global_news](https://github.com/user-attachments/assets/44f09387-024a-4028-95ea-f1b6bd0ae7ae)


Design Philosophy:
Global News is designed to provide users with easy access to global news in a seamless and user-friendly manner. The app focuses on delivering a smooth user experience while ensuring that users can easily find and read news articles relevant to their interests and location.

