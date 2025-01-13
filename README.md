# TheMovieDB iOS App

This iOS application is built using Swift and the Combine framework, showcasing a clean architecture with MVVM and Coordinator pattern, network handling, and UI implementation using SnapKit. It interacts with The Movie Database (TMDb) API to fetch popular movies and allow users to search for movies by name.

## Features

- **Popular Movies List**: Displays a list of popular movies using the TMDb API.
- **Search Movies**: Allows users to search for movies by name.
- **Movie Details**: Clicking on a movie opens a details page with more information such as title, release date, rating, and backdrop image.

## Technologies Used

- **Swift**: The primary programming language.
- **Combine**: For handling asynchronous data streams and reactive programming.
- **SnapKit**: For easy layout management.
- **SDWebImage**: For loading images asynchronously.
- **TMDb API**: For fetching movie data.

## Architecture

This project follows the **MVVM** (Model-View-ViewModel) architecture along with **Clean Architecture** principles and Coordinator pattern, making the codebase modular, maintainable, and easy to scale.

### Layers:
1. **Model**: Represents the data (Movie, API responses, etc.).
2. **View**: The UI components such as `MovieListViewController` and `MovieDetailsViewController`.
3. **ViewModel**: The intermediary between the view and use cases, responsible for fetching data and providing it to the view.
4. **UseCases**: The business logic layer that interacts with the repository to fetch data.
5. **Repository**: Responsible for fetching data from the network layer and providing it to the use cases.


## Setup

### Requirements

- Xcode 13.0 or later
- Swift 5.0 or later
- macOS 10.15 or later

### Installation

1. Clone the repository:
```bash
  git clone https://github.com/YaserBahrami/TheMovieDB.git
```
2. Navigate to the project directory:
```bash
  cd TheMovieDB
```
3. Install dependencies using Cocoapods:
```bash
  pod install
```
4. Open the project in Xcode:
```bash
  open TheMovieDB.xcworkspace
```

### Dependencies

- **Combine**: For managing reactive streams.
- **SnapKit**: For AutoLayout in code.
- **SDWebImage**: For asynchronous image loading.

## Usage

1. **Popular Movies**: Upon app launch, you will see a list of popular movies fetched from The Movie Database API.
2. **Search**: You can search for movies by typing in the search bar. The app will filter results based on the search query.
3. **Movie Details**: Clicking on any movie will show a detail screen with more information, including a backdrop image, rating, and release date.

## App Flow

- **Home Screen**: Displays a list of popular movies.
- **Search**: Allows users to search for movies by title.
- **Movie Details Screen**: Shows detailed information about a selected movie.


## Improvements (If More Time Was Available)

If I had more time, the following improvements and features could be added:

### 1. **Pagination and Lazy Loading**
- The app currently fetches only the first page of movies. Implementing pagination would load additional pages as the user scrolls, improving performance and reducing load times.

### 2. **Error Handling and User Feedback**
- Improve the error handling UI, such as showing a retry button when a network request fails, instead of just displaying an error message.
- Add better user feedback during loading states, such as a spinner or a loading animation.

### 3. **Unit and UI Testing**
- Write unit tests for use cases, view models, and repositories.
- Implement UI tests for ensuring the functionality of the search bar, movie list, and movie details screen.

### 4. **Localization**
- Add support for multiple languages to make the app accessible to users around the world.

### 5. **Third-Party Dependencies**
- If I had more time, I would avoid using third-party libraries like SDWebImage and SnapKit, opting for native solutions instead. 


## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) license


