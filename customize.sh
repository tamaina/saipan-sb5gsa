REPLACE="
"

APILEVEL=$(getprop ro.build.version.sdk)
if [ $APILEVEL -lt 31 ] ; then
	abort "Only Android 12+ is supported, sorry."
fi

MODEL=$(getprop ro.opa.device_model_id)
if [ $MODEL = "motorola-saipan" ] ; then
	abort "Only motorola-saipan (moto g50 5G) is supported."
fi

