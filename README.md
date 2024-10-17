# RecipeMobile
An App that displays recipes from a provided endpoint


https://github.com/user-attachments/assets/3184078e-f0d1-49a3-a6c8-8a0493353fa9


### Steps to Run the App
Open the project and wait for the dependencies to download.
CMD + R to run the code.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I started with the Network service and the Endpoint for making the requests. 

That part of the code is reused all the time, for new requests we need new endpoints. When the project starts, everyone that is working on a new API request will have to make a new endpoint/request so that part must be finished ASAP.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
- I spent 2 hours.
- I spent half of the time creating the network service, the error handling and the endpoint protocol for easy request creations. And I spent a good time testing it worked taking care I didin't miss anything.
- I spent the other half in the UI and Unit test but most of that time in the UI trying to make it look better.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I was going to make a push navigation for the photo, website and the video, but I decided to make them modals because when I finish what I'm doing to go back quickly to the main screen.
I used safariViewController because it's a good way to see a website without leaving the app and I thought that WKWebView would be too much just to show an URL without more interaction. 

### Weakest Part of the Project: What do you think is the weakest part of your project?
Unit Tests.  I didn't use third party libraries so I know that can be done better. I don't use libraries for networking since URLSession now has everything we need for async await.  Having a good network code snippet is essential. 

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?
I used kingFisher for caching the images, it is lightweight and it's better than the Buggy AsyncImage that SwiftUI provides.

I asked chatGpt to give me the generic codable to save time but I regreted ended using the same protocol I use in my repo https://github.com/oscast/ios-gpt where I use EndPoint protocol to make easy requests, also the error handlers and the service.  I believe we should have the network layer code in Xcode snippets.

I used chat gpt for the full screen HD image. It's not the first time I asked that view so I feel ashamed that I don't have that in a Github Gist.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
