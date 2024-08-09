Project Name: Global News
Description:

Global News is a mobile application that provides users with up-to-date global news articles. The app fetches news articles using an API and displays them based on the user's location and preferences. With a focus on user-friendly design and seamless experience, Global News ensures that users have easy access to the latest news from around the world.

Features:

Splash Screen:
A splash screen is displayed upon launching the app, enhancing the user interface experience.

Home Screen:
The home screen displays top headlines at the top and other news articles below, based on the default country determined by the device's location.
Users can navigate to a categories screen via the categories selection button in the app bar.
The app bar also includes a search feature and a country selection button.

Search Feature:
Users can tap on the search icon to enter queries and retrieve articles related to their interests.

Country Selection:
By tapping on the country select icon, users can view a list of countries in a drawer and choose one to see articles relevant to that country.

Categories Screen:
Displays articles by category for the selected country, including "General," "Sports," "Business," "Technology," "Health," "Entertainment," and "Science."
Users can tap on a category to view articles related to that category.

List Display Features:

Shimmer Effect: Displays a loading effect until data is fetched from the API.

LazyLoader: Loads more data as the user scrolls to the end of the list.

RefreshIndicator: Allows users to refresh the data by pulling down on the screen.

Important Notes:
. Users must grant location permission for the app to function, as it uses the device's location to fetch news data.

. Users may need to refresh the screen after allowing location access from the settings for the first time.

. The API may not provide perfectly accurate data, as it does not support fetching articles solely by country. This is particularly relevant for top headlines. For more information about the API, visit News API: "https://newsapi.org/"

Technologies Used:

Flutter: The primary framework for building the mobile application.

Dart: The programming language used with Flutter.

News API: For fetching global news articles.

Usage Flow:
The user opens the Global News app.
The splash screen is displayed.
The user is taken to the home screen, where top headlines and other news articles are displayed based on the default country.
The user can search for specific articles using the search feature.
The user can select a different country to view news articles specific to that location.
The user can navigate to the categories screen to view articles by category.
The user can refresh the data using the RefreshIndicator.

Design Philosophy:

Global News is designed to provide users with easy access to global news in a seamless and user-friendly manner. The app focuses on delivering a smooth user experience while ensuring that users can easily find and read news articles relevant to their interests and location.

