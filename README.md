Project Name: Global News
Description:

Global News is a dynamic mobile application built using Flutter and Dart, designed to keep users informed with up-to-date global news articles. The app fetches news articles using an API and displays them based on the user's location and preferences. With a focus on user-friendly design and seamless experience, Global News ensures that users have easy access to the latest news from around the world. The app features a splash screen that transitions smoothly into the Home screen, where users are presented with top headlines and other news stories based on their country, automatically determined by the device location.

Click on Image to download apk file of this project:

[![Download APK](![ic_launcher](https://github.com/user-attachments/assets/70b39065-08ba-4d7d-87a0-c1735dedbc2f)
)](https://github.com/ArpitAswal/Global-News/releases/download/1.0.0/GlobalNews.apk)

Features:

Splash Screen:
A splash screen is displayed upon launching the app, enhancing the user interface experience.

Home Screen:
The home screen displays the top headlines at the top and other news articles below, based on the selected country determined by the device's location.
The Home screen has been upgraded with a user-friendly interface that provides feedback for various conditions, ensuring a clear experience for users. Whether the data fetch returns empty results, encounters an error, or reaches the end of available news, appropriate messages and widgets are displayed to keep the user informed. Users can toggle between categories and countries easily, accessing the latest news by simply tapping or swiping.

Search Feature:
In the Search screen, users can input specific queries to find articles of interest. They can also clear the search results with a single button press, streamlining navigation and exploration within the app.

Country Selection:
By tapping on the country select icon, users can view a list of countries in a drawer and choose one to see articles relevant to that country.

Categories Screen:
Displays articles by category for the selected country, including "General," "Sports," "Business," "Technology," "Health," "Entertainment," and "Science."
Users can tap on a category to view articles related to that category.

NewsDetail Screen:
When users select an article, they are directed to the NewsDetail screen. This screen provides comprehensive information about the selected article, including the image, title, content, description, source URL, author, publication date, and source. It offers an immersive reading experience tailored for easy access to the full article details.

Voice Text Feature: 
For added accessibility, the NewsDetail screen includes a voice text feature. Users can listen to the article's title, description, and content read aloud by simply tapping a button in the bottom-right corner. This feature enhances usability for readers who prefer or require audio content delivery.

List Display Features:

Shimmer Effect: Displays a loading effect until data is fetched from the API.

LazyLoader: Loads more data as the user scrolls to the end of the list.

RefreshIndicator: Allows users to refresh the data by pulling down, on the screen.

Gemini AI Chatbox: 
The app introduces the Gemini AI Chatbox, powered by the Gemini-1.5-flash model. Available on nearly every screen, this AI assistant allows users to ask questions and receive informative responses with up to 80-90% accuracy, though without creative interpretations or confidential information. Users can easily access the chatbox at the bottom-right corner of the screen and close it by swiping left, making it a convenient yet unobtrusive feature.

Important Notes:

. Users must grant location permission for the app to function, as it uses, the device's location to fetch news data.

. Users may need to refresh the screen after allowing location access from the settings for the first time.

. The API may not provide, perfectly accurate data, as it does not support fetching articles solely by country. This is particularly relevant for top headlines. For more information about the API, visit News API: "https://newsapi.org/"

Future Updates:
In future releases, Global News will include several new features to enhance customization and personalization:

Advanced Filtering: Users will be able to filter the news list by date ranges, allowing them to view articles published within specific periods (e.g., X to Y date). Additional sorting options will include relevance, popularity, and publication date, giving users more control over how they view news stories.

User Account and Saved Articles: The app will offer user account profiles where they can manage their information and preferences. Within their profile, users will have access to a Favorites Section to save or like articles they want to revisit. This feature will allow users to save articles directly from the NewsDetail screen, creating a personalized library of favourite content.

Sign-In and Sign-Out: The addition of sign-in and sign-out options will support the Favorites Section, allowing users to maintain their saved articles across devices and sessions.

Technologies Used:

Flutter: The primary framework for building the mobile application.

Dart: The programming language used with Flutter.

News API: For, fetching global news articles.

Gemini API: To get the response of user prompt by AI assistant

Usage Flow:
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

