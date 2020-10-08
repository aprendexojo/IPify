#tag Module
Protected Module IPify
	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub ChangeNotification()
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h21
		Private Sub CheckChangeAction(toSender as Timer)
		  #pragma unused toSender
		  
		  // Get current IP
		  var tsCurrentIP as String = CurrentIP.Trim
		  
		  // If we don't yet have a history, store and be done
		  if marsKnownAddresses.LastRowIndex < 0 then
		    marsKnownAddresses.AddRow(tsCurrentIP)
		    return
		    
		  end
		  
		  // You could check through all of history here if you wanted
		  
		  // Check last address for current address
		  if marsKnownAddresses(marsKnownAddresses.LastRowIndex) <> tsCurrentIP then
		    // Address has changed
		    // Store the change before calling the delegate so that an extremely
		    // long delegate can't make this notification happen twice
		    StashAddress(tsCurrentIP)
		    
		    if moChangeDelegate <> nil then
		      moChangeDelegate.Invoke
		      
		    end
		    
		  else
		    // Address has not changed
		    StashAddress(tsCurrentIP)
		    
		  end
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub CheckForChangeEvery(tiMinutes as Integer = 30, toNotificationReceiver as IPify.ChangeNotification)
		  // Construct timer
		  if moChangeTimer = nil then
		    moChangeTimer = new Timer
		    
		    AddHandler moChangeTimer.Action, AddressOf CheckChangeAction
		    
		  end
		  
		  // Store the delegate
		  moChangeDelegate = toNotificationReceiver
		  
		  // Start watching for changes
		  moChangeTimer.Period = tiMinutes * 60 * 1000
		  moChangeTimer.RunMode = Timer.RunModes.Multiple
		  moChangeTimer.Reset
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function CurrentIP() As String
		  var toRequest as new URLConnection
		  var tsResponse as String = toRequest.SendSync("GET", kAPIURL, 3)
		  
		  return tsResponse
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub StashAddress(tsAddress as String)
		  // Trim whitespace
		  tsAddress = tsAddress.Trim
		  
		  // Find it
		  var tiIndex as Integer = marsKnownAddresses.IndexOf(tsAddress)
		  
		  // Move it to top of stack
		  if tiIndex > -1 then
		    marsKnownAddresses.RemoveRowAt(tiIndex)
		    
		  end
		  
		  // Stash it
		  marsKnownAddresses.AddRow(tsAddress)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StopChecking()
		  if moChangeTimer <> nil then
		    moChangeTimer.RunMode = Timer.RunModes.Off
		    
		  end
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private marsKnownAddresses() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private moChangeDelegate As IPify.ChangeNotification
	#tag EndProperty

	#tag Property, Flags = &h21
		Private moChangeTimer As Timer
	#tag EndProperty


	#tag Constant, Name = kAPIURL, Type = String, Dynamic = False, Default = \"https://api.ipify.org", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVersion, Type = Double, Dynamic = False, Default = \"2.0", Scope = Protected
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
