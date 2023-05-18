Get-Content $env:LOCALAPPDATA\Prospect\Saved\Logs\Prospect.log -wait | Select-String 'LogLoad: LoadMap' | ForEach-Object {
  $line = $_
  $date,$message = $line -split ']'[0], 2
  $date = ($date -replace '\[','').Split(':')[0]
  if ( $line -match 'Login') {
    $IP="0.0.0.0"
    $PORT="0"
    $CC=""
  }
  else {
    $IP,$PORT = (($message  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}:\d{1,5}" -AllMatches).Matches.Value).Split(':')
    $CC = ((Invoke-WebRequest -Uri http://ip-api.com/line/$($IP)?fields=countryCode | Select-Object -ExpandProperty Content).Trim())
  }
  $map = ($message).Split('/')[4]
  echo "$date $($IP):$PORT $CC $map"
}