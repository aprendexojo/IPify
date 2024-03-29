#tag Class
Protected Class IPify
Implements actionNotificationReceiver
	#tag Method, Flags = &h0
		Shared Function changedIP() As Dictionary
		  Var currentCount As Integer = getInstance.ips.LastIndex
		  
		  Call getInstance.getIp
		  
		  Var d As New Dictionary
		  
		  d.value(kChangedIP) = If(currentCount = getInstance.ips.LastIndex, False, True)
		  d.value(kCurrentIP) = getInstance.ips(getInstance.ips.LastIndex)
		  
		  Return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub checkForIPChangeEvery(minutes as integer = kDefaultMinutes, notifyTo as IPifyNotificationReceiver)
		  
		  ListenerToNotify = Nil
		  ListenerToNotify = notifyTo
		  
		  If minutes <= 0 Then minutes = kDefaultMinutes
		  
		  If CheckerTimer <> Nil Then 
		    
		    CheckerTimer.RunMode = timer.RunModes.Off
		    
		  Else
		    
		    CheckerTimer = New timer
		    CheckerTimer.addActionNotificationReceiver getInstance
		    
		  End If
		  
		  CheckerTimer.Period = minutes * 60 * 1000
		  CheckerTimer.RunMode = timer.RunModes.Multiple
		  CheckerTimer.Enabled = true
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function currentIP() As String
		  
		  Var instance As IPify = getInstance
		  
		  Var ip As String = instance.getIp
		  
		  Return ip
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub destructor()
		  ListenerToNotify = Nil
		  
		  CheckerTimer.RunMode = timer.RunModes.Off
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
		  Var request As New URLConnection
		  
		  Try
		    Var ip As String = request.SendSync("Get",remoteAPI,10)
		    
		    
		    If ips.LastIndex = -1 Or ip <> ips(ips.LastIndex) Then 
		      
		      ips.add ip
		      
		    End If
		    
		    Return ip
		    
		  Catch e As RuntimeException
		    
		    Var err As New RuntimeException
		    err.ErrorNumber = 100
		    err.Message = kAPINoReachableMessage
		    
		    Raise err
		    
		  End Try
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PerformAction()
		  // Part of the actionNotificationReceiver interface.
		  
		  If ListenerToNotify <> Nil Then
		    
		    ListenerToNotify.IPChanged(changedIP)
		    
		  Else
		    
		    stopChecking
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Sub stopChecking()
		  CheckerTimer.RunMode = timer.RunModes.Off
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


	#tag Constant, Name = kAPINoReachable, Type = Text, Dynamic = True, Default = \"API no reachable", Scope = Private
		#Tag Instance, Platform = Any, Language = es, Definition  = \"API no disponible"
	#tag EndConstant

	#tag Constant, Name = kAPINoReachableMessage, Type = Text, Dynamic = True, Default = \"It is not possible to reach the remote API\x2C maybe the Internet connection is down or the remote server is offline.", Scope = Private
		#Tag Instance, Platform = Any, Language = es, Definition  = \"No est\xC3\xA1 disponible la API remota\x2C quiz\xC3\xA1 est\xC3\xA9 ca\xC3\xADda la conexi\xC3\xB3n a Internet o bien no est\xC3\xA9 disponible el servidor remoto."
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
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
