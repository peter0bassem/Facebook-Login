# Facebook-Login

Instructions:

1- create a new project in xcode.

2- open https://developers.facebook.com/

3- Add a new app

4- Enter display name in the alert and click Create App ID

5- From dashboard click Facebook Login.

6- Select iOS 

7- select SDK: Cocoapods

if you don't have cocoapods installed on your mac open terminal and write this line and press ender sudo gem install cocoapods

8- open project in terminal then open termainl then write cd and drag project folder to termianl and press enter.

9- open Podfile file by command "open -a Xcode Podfile" or with any edit text app.

10- add pod 'FBSDKLoginKit'

11- run pod install in terminal

12- after pod install, open .xcworkspace project file and copy Bundle identifier from General in app targets.

13- go back to developers.facebook.com, click save, then paste bundle id in edit text, click save and continue.

14- Enable Single Sign on, click save and continue.

15- copy snippet from website and go back to xcode, right click on info.plist and open as source as source code, go to the bottom of the file before close of plist and dict and paste, go back to website and copy the next code snippet and paste it in info.plist, then click next

16- copy Appdelegate snippet and paste in Appdelegate file in xcode 

17- Copy Scenedelegate snppet and paste in Scenedelegate file in xcode (if using ios 13), then click next.

==> If you want to add button programmatically 
  copy code in your loginviewcontroller, set delegate for button as follows: loginButton.delegate = self
  then add extension for facebook login delegate functions
  
  ```
  override func viewDidLoad() {
    super.viewDidLoad()
    let loginButton = FBLoginButton()
    loginButton.center = view.center     // Add the button to the center of the screen.
    loginButton.delegate = self
    loginButton.permissions = ["public_profile", "email"]
    view.addSubview(loginButton)
  }
  ```
  
  ```
  extension ViewController: LoginButtonDelegate {
    
      func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
          let token = result?.token?.tokenString

          getFacebookUser(token)
      }

      func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
          print("logged out successfully")
      }
}
```

  and then if you want to check if user has logged before or token is not expirded
  
  in ```viewDidLoad``` check that
  
  ```
  override func viewDidLoad() {
    super.viewDidLoad()
    if let token = AccessToken.current, !token.isExpired {
      let token = token.tokenString
      getFacebookUser(token)
    }
  }
  
  func getFacebookUser(_ token: String?) {
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result, error) in
            if let error = error {
                print("facebook login error:", error)
                return
            }
            print("\(result)")
        }
    }
  ```

use the result to presist user data to userDefaults, or send user data to API, then navigate to home screen.

==> If you want to add a custom button from storyboard:

add your button (UIButton) from storyboard and connect it's action as

```
@IBAction func onFacebookLoginButtonPressed(_ sender: UIButton) {
        let facebookLoginManager = LoginManager()
        facebookLoginManager.logIn(permissions: ["public_profile", "email", "user_gender", "user_birthday"], from: self) { [weak self] (result, error) in
            if let error = error {
                print("Faile to login with facebook:", error)
                return
            }
            guard let result = result else { return }
            if result.isCancelled {
                print("User cancelled facebook login")
                return
            }
            let token = result.token?.tokenString
            self?.getFacebookUser(token)
        }
    }
```

And continue as above.

------------------------------------------------------------------------------------------------------------------------------

If you want to get more user info as profile picture, gender, etc... Follow what is happeining 😁

• For User profile picture: add to Graph request per: picture.type(large) // profile image sizes: small, normal, album, large, square

• For User first name, middle nams and last name: add to Graph request per: first_name, middle_name, last_name respectively

• For User Gender: add to Graph request per: gender and in loginButton.permissions/facebookLoginManager.logIn(permissions: user_gender

• For User Birthday: add to Graph request per: birthday and in loginButton.permissions/facebookLoginManager.logIn(permissions: user_birthday

The final loginButton.permissions/facebookLoginManager.logIn(permissions: should be = ["public_profile", "email", "user_gender", "user_birthday"]

The Final Graph request permissions should be = ["fields": "email, name, first_name, last_name, middle_name, picture.type(album), gender, birthday"]

Important Note: You cannot get user phone number.
