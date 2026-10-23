# Package lists used by debloat.ps1 / restore.ps1.
# Everything here is disabled with `pm disable-user --user 0`, never uninstalled,
# so restore.ps1 (or a factory reset) brings it all back.

# Ads, tracking and junk. Safe to disable on the AIWA KTC_AIWA_4K_SA_21V2.
$Bloat = [ordered]@{
    'tv.anoki.acr.controller'                               = 'Anoki ACR: watches what is on screen for ad targeting'
    'com.cltv.fast'                                         = 'FAST free ad-supported channels'
    'com.google.android.tvrecommendations'                  = 'Sponsored / recommended rows on the home screen'
    'com.mediatek.android.leanbacklauncher.partnercustomizer' = 'Partner (vendor) promoted rows and app slots'
    'android.autoinstalls.config.ktc.pai'                   = 'Play auto-install: silently pushes partner apps'
    'fusion.android.tv.demo'                                = 'Store demo mode'
    'com.google.android.play.games'                         = 'Google Play Games'
    'com.google.android.feedback'                           = 'Google feedback/crash reporter'
}

# Apps you may still want. Only disabled with debloat.ps1 -IncludeOptional.
$Optional = [ordered]@{
    'com.google.android.youtube.tvmusic'   = 'YouTube Music'
    'com.amazon.amazonvideo.livingroom'    = 'Prime Video'
    'com.netflix.ninja'                    = 'Netflix'
}

# Stock Google TV launcher (has the ad banner). Only disabled with -ReplaceLauncher,
# and only after another launcher is installed.
$StockLauncher = 'com.google.android.tvlauncher'
