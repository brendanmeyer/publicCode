Add-Type -TypeDefinition @"
using System; 
using System.Runtime.InteropServices; 

public static class SleepUtil
{
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern EXECUTION_STATE SetThreadExecutionState(EXECUTION_STATE esFlags);

    [FlagsAttribute]
    public enum EXECUTION_STATE : uint
    {
        ES_SYSTEM_REQUIRED = 0x00000001,
        ES_DISPLAY_REQUIRED = 0x00000002,
        // Legacy flag, should not be used.
        // ES_USER_PRESENT   = 0x00000004,
        ES_AWAYMODE_REQUIRED = 0x00000040,
        ES_CONTINUOUS = 0x80000000,
    }

    public static void PreventSleep()
    {
        if (SleepUtil.SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS
            | EXECUTION_STATE.ES_DISPLAY_REQUIRED
            | EXECUTION_STATE.ES_SYSTEM_REQUIRED
            | EXECUTION_STATE.ES_AWAYMODE_REQUIRED) == 0) //Away mode for Windows >= Vista
            SleepUtil.SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS
                | EXECUTION_STATE.ES_DISPLAY_REQUIRED
                | EXECUTION_STATE.ES_SYSTEM_REQUIRED); //Windows < Vista, forget away mode
    }

    public static void AllowSleep()
    {
        SleepUtil.SetThreadExecutionState(EXECUTION_STATE.ES_CONTINUOUS);
    }
}
"@


[SleepUtil]::PreventSleep()
[SleepUtil]::AllowSleep()


