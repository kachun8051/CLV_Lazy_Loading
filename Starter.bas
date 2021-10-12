B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=7.8
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
	Type AirportData (Name As String, AirportID As Int, IATA As String, ICAO As String, City As String, Latitude As Float, Longitude As Float, Altitude As String)

	Public SQL As SQL
	Public RTP As RuntimePermissions
	Public SafeDirectory As String
	Public DBName As String = "Airports.db"
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.

	SafeDirectory = RTP.GetSafeDirDefaultExternal("")
	
	If File.Exists(SafeDirectory, DBName) = False Then
		Wait For (File.CopyAsync(File.DirAssets, DBName, SafeDirectory, DBName)) Complete (Success As Boolean) 'File.DirInternal
		ToastMessageShow($"DB Copied = ${Success}"$, False)
		CallSubDelayed3(Main, "TxtSearchFilter_TextChanged", "", "")
'		Log("Success: " & Success)
	End If
	
	ConnectToDatabase
	Wait For SQLite_Ready (Success As Boolean)
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy
End Sub

'CONNECT TO DATABASE A LOAD SETTINGS
Public Sub ConnectToDatabase
	SQL.Initialize(SafeDirectory, DBName, False)
End Sub
