# IPify for Xojo
Xojo Class for using IPify service from Desktop apps

This is a Singleton class that uses the remote IPify web service in order to get the external IP address used by the app (if any) in order to access the Internet.

## How to use IPify for Xojo
Just copy and paste (or drag and drop) the **IPify** folder from the project included into your own Xojo project.

This folder contains:

+ **IPify**. This is the Singleton Class you will use.
+ **IPifyNotificationReceiver**. This is the Class interface you have to add to any object you want to receive notifications from IPify.

## Getting the current IP
In order to know the current external (or public) IP, you only need to use this line of code:
```
Dim ip as String = IPify.currentIP
```
## Check if the IP has changed
If you are interested in knowing if the public IP has changed, then use the following code:
```
Dim d as dictionary = IPify.changedIP
```
The returned status dictionary has two keys:
+ **`IPify.kChangedIP`**. Returns `True` if the IP has changed since last check, and `False` otherwise.
+ **`IPify.kCurrentIP`**. The value referenced by this key is the current public IP.
## Checking periodically for the IP
It is also possible to instruct **IPify** for Xojo to check periodically the public IP. In this case, the method to invoke expects to parameters:
+ **minutes**. The first argument is the time interval between IP checkings, indicated as minutes (defaults to 30 minutes).
+ **notificationReceiver**. This parameter expects and object that conforms to the **IPifyNotificationReceiver** Class interface, and that will receive the IPify status dictionary at the specified intervals.

To stop checking periodically the IP, just call:
`
IPify.stopChecking
`
