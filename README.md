# flores_mobprog
Lawrenz Dave Zubiri Flores
Bachelor of Science Information Technology -Mobile Web Application
INF233

So basically, how Models, Services, and Screens all work together in this app is a pretty straightforward cycle:

Screens handle the user side of things: When someone taps around the app—like logging in on the SigninScreen, checking out posts on the NewsFeedScreen, or dropping a comment on the DetailScreen—the screen itself doesn't actually go out and make network requests. Instead, it just asks the Service layer to do the heavy lifting by calling methods like UserService.login(), PostService.getPosts(), or CommentService.addComment().

Services take care of the backend and mapping: The Service handles hitting the DummyJSON API (or handling SharedPreferences locally). Once raw JSON comes back, the Service uses the Model's fromJson() factory constructor to turn that raw map into clean, strongly typed Dart objects like User, Post, or Comment.

Models pass structured data back to the UI: The Model makes sure everything—IDs, text, author names, likes—is fully type-safe and won't throw null errors on us. The Service then passes these Model objects straight back to the Screen, where standard Flutter widgets like FutureBuilder, ListView.builder, and setState() instantly render everything for the user.

To wrap it up, Screens deal with user input and what's on screen, Services manage the logic and talking to the backend, and Models act as our data blueprint to safely pass and format everything cleanly between the services and the screens.
