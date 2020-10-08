# IPify for Xojo
Xojo Module for using IPify service to query the public IP address.

## How to use IPify for Xojo
Copy and paste the **IPify** module to the destination project. The functions on the module are protected, so use the fully qualified namespace for code clarity.

## Getting the current address
To get the current external (or public) IP address use the `CurrentIP` function.
```
var sIPAddress as String = IPify.CurrentIP
```

## Check if the address has changed
To continually poll the public IP address and receive a notification when it has changed use the `CheckForChangeEvery` function. A delegate method is required. This method will be called when the IP address has changed.

To stop listening call `StopChecking`. This will *not* clear the notification delegate, though there is currently no way to re-use the original delegate.