#tag Class
Protected Class IPify
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Shared Function changedIP() As Dictionary
		  Dim currentCount As Integer = getInstance.ips.Ubound
		  
		  Call getInstance.getIp
		  
		  Dim d As New Dictionary
		  
		  d.value(kChangedIP) = If(currentCount = getInstance.ips.Ubound, False, True)
		  d.value(kCurrentIP) = getInstance.ips(getInstance.ips.Ubound)
		  
		  return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub checkForIPChangeEvery(minutes as integer = kDefaultMinutes, notifyTo as IPifyNotificationReceiver)
		  
		  ListenerToNotify = Nil
		  ListenerToNotify = notifyTo
		  
		  if minutes <= 0 then minutes = kDefaultMinutes
		  
		  If CheckerTimer <> Nil Then 
		    
		    CheckerTimer.Mode = timer.ModeOff
		    
		  Else
		    
		    CheckerTimer = New timer
		    CheckerTimer.addActionNotificationReceiver getInstance
		    
		  End If
		  
		  CheckerTimer.Period = minutes * 60 * 1000
		  CheckerTimer.Mode = timer.ModeMultiple
		  CheckerTimer.Enabled = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function currentIP() As String
		  
		  Dim instance As IPify = getInstance
		  
		  Dim ip As String = instance.getIp
		  
		  Return ip
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub destructor()
		  ListenerToNotify = Nil
		  
		  CheckerTimer.Mode = timer.ModeOff
		  CheckerTimer.Enabled = False
		  CheckerTimer = Nil
		  
		  globalInstance = Nil
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function getInstance() As ipify
		  If globalInstance = Nil Then globalInstance = New IPify
		  
		  Return globalInstance
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getIp() As String
		  Dim request As New HTTPSecureSocket
		  
		  Dim ip As String = request.Get(remoteAPI,10)
		  
		  If request.ErrorCode = -1 Then
		    
		    Dim err As New RuntimeException
		    err.ErrorNumber = 100
		    err.Reason = kAPINoReachable
		    err.Message = kAPINoReachableMessage
		    
		    Raise err
		    
		  End If
		  
		  If ips.Ubound = -1 or ip <> ips(ips.Ubound) Then 
		    
		    ips.Append ip
		    
		  End If
		  
		  Return ip
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PerformAction()
		  // Part of the actionNotificationReceiver interface.
		  
		  ListenerToNotify.IPChanged(changedIP)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub stopChecking()
		  CheckerTimer.Mode = timer.ModeOff
		  CheckerTimer.Enabled = false
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared CheckerTimer As timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared globalInstance As IPify
	#tag EndProperty

	#tag Property, Flags = &h21
		Private ips() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared ListenerToNotify As IPifyNotificationReceiver
	#tag EndProperty


	#tag Constant, Name = kAPINoReachable, Type = Text, Dynamic = False, Default = \"API no reachable", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAPINoReachableMessage, Type = Text, Dynamic = False, Default = \"It is not possible to reach the remote API\x2C maybe the Internet connection is down or the remote server is offline.", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kChangedIP, Type = String, Dynamic = False, Default = \"ChangedIP", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kCurrentIP, Type = String, Dynamic = False, Default = \"CurrentIP", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kDefaultMinutes, Type = Double, Dynamic = False, Default = \"30", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kNoIP, Type = String, Dynamic = False, Default = \"No public IP available", Scope = Private
	#tag EndConstant

	#tag Constant, Name = remoteAPI, Type = String, Dynamic = False, Default = \"https://api.ipify.org", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
