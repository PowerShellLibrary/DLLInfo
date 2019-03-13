function Get-BuildConfiguration {
    [cmdletbinding()]
    param (
        [string]$dllPath
    )
    $dll = [System.Reflection.Assembly]::LoadFile($dllPath)
    $type = [System.Type]::GetType("System.Diagnostics.DebuggableAttribute")
    $debugAttribute = $dll.GetCustomAttributes($type, $false)
    if ($debugAttribute.IsJITTrackingEnabled) {
        "Debug"
    }
    else {
        "Release"
    }
}