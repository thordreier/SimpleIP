# Override Write-Verbose in this module so calling function is added to the message
function script:Write-Verbose
{
    [CmdletBinding()]
    param
    (
       [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)] [String] $Message
    )

    begin
    {}

    process
    {
        try
        {
            $PSBoundParameters['Message'] = $((Get-PSCallStack)[1].Command) + ': ' + $PSBoundParameters['Message']
        }
        catch
        {}

        Microsoft.PowerShell.Utility\Write-Verbose @PSBoundParameters
    }

    end
    {}
}
