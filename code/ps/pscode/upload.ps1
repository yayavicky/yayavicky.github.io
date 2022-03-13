param (
    $xmlData = [xml](Get-Content "D:\del\pstest\upload.xml"),
    $localPath = $xmlData.ftpConfig.LocalPath,
    $remotePath = $xmlData.ftpConfig.RemotePath,
    $dllPath = $xmlData.ftpConfig.DllPath,
    $logDir = $xmlData.ftpConfig.LogDir,
    $tasks = $xmlData.ftpConfig.Task.Item    
)

function write_log_file($message) {
    (Get-Date).ToString() + " - " + $message  >> $log_file_path
}
function write_error_log($message) {
    (Get-Date).ToString() + " - " + $message  >> $error_log_file
}

function wait10sec {
    $step = 10
    $add = 0
    $t = (Get-Date)
    $step - (($t.Hour * 3600 + $t.Minute * 60 + $t.Second) % $step) + $add
}


function upload_file( $ftpSession, [string]$localFile, [string]$remoteDir) {
    write_log_file "Will upload ${localFile} to $remoteDir"
    $ftpSession.PutFiles($localFile, $remoteDir).Check() 
    write_log_file "Finish upload ${localFile} to $remoteDir "
}



try {
    $log_file_path = Join-Path -Path $logDir -ChildPath ("info_" + (Get-Date -Format "yyyy-MM-dd") + ".log")
    $error_log_file = Join-Path -Path $logDir -ChildPath ("error_" + (Get-Date -Format "yyyy-MM-dd") + ".log")
    Add-Type -Path $dllPath
    
    $sessionOptions = New-Object WinSCP.SessionOptions
    $sessionOptions.Protocol = [WinSCP.Protocol]$xmlData.ftpConfig.Protocol
    $sessionOptions.HostName = $xmlData.ftpConfig.HostName
    $sessionOptions.UserName = $xmlData.ftpConfig.UserName
    $sessionOptions.Password = $xmlData.ftpConfig.Password

    $session = New-Object WinSCP.Session

    try {
        # Connect
        $session.Open($sessionOptions)
      
        write_log_file "Start uploading..."       
        
        Foreach ($task in $tasks) {            
            $localPath = $task.LocalPath 

            write_log_file "Will upload Files in $localPath"
            $file_list = (Get-ChildItem -Path $localPath -File | % { $_.FullName })

            Foreach ($file_item in $file_list) {
                upload_file  $session $file_item  $task.RemotePath
            }    
    
        }
        
        write_log_file "End upload"

    }
    finally {
        # Disconnect, clean up
        $session.Dispose()
    }

    exit 0

}
catch [Exception] {
    Write-Host("Error:{0}" -f $_.Exception.Message)
    exit 1
}

echo "--------------------"
echo $xmlData
echo "--------------------"
echo $localPath
echo "--------------------"
echo $remotePath
echo "--------------------"
echo $dllPath