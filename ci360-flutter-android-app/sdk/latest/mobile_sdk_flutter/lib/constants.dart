const String sharedPrefsName = "com.sas.mkt.mobile.sdk.SASCollector";
const String SHARED_PREFS_KEY_DEVICE_ID = "device.id";
const String SHARED_PREFS_KEY_FENCES = "geofences";
const String SHARED_PREFS_KEY_MOBILE_MESSAGE_ICON_RESOURCE =
    "mobile.message.icon.resource";
const String SHARED_PREFS_KEY_MOBILE_MESSAGE_ICON_COLOR_RESOURCE =
    "mobile.message.icon.color.resource";
const String SHARED_PREFS_KEY_LOCATION_MONITORING_DISABLED =
    "location.monitoring.disabled";
const String SHARED_PREFS_KEY_LOCATION_PERMISSION_PROMPT_ENABLE =
    "location.permission.prompt.enable";
const String SHARED_PREFS_KEY_CURRENT_FENCE = "current.fence";
const String SHARED_PREFS_KEY_PUSH_NOTIFICATION_CHANNEL_ID =
    "push.notification.channel.id";

const String PLATFORM = "Android";
const String DEVICE_TYPE_PHONE = "phone";
const String DEVICE_TYPE_TABLET = "tablet";
const double TABLET_MIN_SCREEN_SIZE = 6.5;

const String EVT_STARTUP = "startup";
const String EVT_FOCUS = "focus";
const String EVT_DEFOCUS = "defocus";
const String EVT_GEOFENCE_ENTER = "enter_geofence";
const String EVT_GEOFENCE_EXIT = "exit_geofence";
const String EVT_SPOT_CONTENT_REQUESTED = "spot_requested";
const String EVT_SPOT_CONTENT_DELIVERED = "spot_change";
const String EVT_SPOT_CONTENT_DEFAULT_DELIVERED = "spot_default_delivered";
const String EVT_SPOT_CONTENT_FAILED = "spot_failed";
const String EVT_SPOT_CONTENT_VIEWABLE = "spot_viewable";
const String EVT_SPOT_CLICK_THROUGH = "spot_clicked";
const String EVT_SPOT_CLOSED = "spot_closed";
const String EVT_BEACON_ENTER = "device_enter_beacon";
const String EVT_IDENTITY = "identity";
// const  String EVT_DEVICE_LOCATION = "device_location";
const String EVT_LOAD = "load";
const String EVT_CART = "cart";
// const  String EVT_FIRST_LAUNCH = "first_launch";

//LOAD
const String EVT_DATA_LOAD_URI = "uri";

//ID_LOGON
const String EVT_DATA_IDENTITY_TYPE = "logon_type";
const String EVT_DATA_IDENTITY_VALUE = "logon_value";

//REGION
const String EVT_DATA_GEOFENCE_REGION = "geofence_id";
const String EVT_DATA_LATITUDE = "geo_latitude";
const String EVT_DATA_LONGITUDE = "geo_longitude";

//SPOTS
const String EVT_DATA_SPOT_ID = "spot_id";
const String EVT_DATA_CREATIVE_ID = "creative_id";
const String EVT_DATA_TASK_ID = "task_id";
const String EVT_DATA_EVENT_ID = "event_id";
const String EVT_DATA_FCID = "FCID";
const String EVT_DATA_URI = "uri";
const String EVT_DATA_REC_GROUP = "rec_group";

//BEACONS
const String EVT_DATA_BEACON_UUID = "beacon_uuid";
const String EVT_DATA_BEACON_MAJOR = "beacon_major";
const String EVT_DATA_BEACON_MINOR = "beacon_minor";

//STARTUP
const String EVT_DATA_PLATFORM = "mobile_platform";
const String EVT_DATA_PLATFORM_VERSION = "mobile_platform_version";
const String EVT_DATA_SDK_VERSION = "mobile_sdk_version";
const String EVT_DATA_DEVICE_TYPE = "mobile_device_type";
const String EVT_DATA_DEVICE_MODEL = "mobile_device_model";
const String EVT_DATA_DEVICE_MFG = "mobile_device_mfg";
const String EVT_DATA_SCREEN_WIDTH = "mobile_screen_width";
const String EVT_DATA_SCREEN_HEIGHT = "mobile_screen_height";
const String EVT_DATA_MOBILE_COUNTRY_CODE = "mobile_country_code";
const String EVT_DATA_MOBILE_NETWORK_CODE = "mobile_network_code";
const String EVT_DATA_CARRIER_NAME = "mobile_carrier_name";
const String EVT_DATA_APP_VERSION = "mobile_app_version";
const String EVT_DATA_APP_LANGUAGE = "mobile_app_language";
const String evtDataDeviceLanguage = "mobile_device_language";
const String evtDataVisitorState = "visitor_state";

const String visitorStateNew = "new";
const String visitorStateReturning = "returning";

const String evtDataCartType = "cart_type";

const String evtDataFlags = "flags";
const String evtDataFlagNewSession = "ns";
const String evtDataFlagNewLoad = "nl";

const String jsonDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

//The values that actually come from IA have different capitalization (e.g. data-creativeID)
//but in the process of bringing the HTML content back to native code over the javascript bridge
//Android seems to change them.
const String dataTagCreativeId = "data-creativeid";
const String dataTagTaskId = "data-taskid";
const String dataTagRecGroup = "data-recgroup";

const String httpClientAgent = "SASCollector";

const String geofenceIndexRegion = "INDEX";

const String iamTemplateLarge = "creative.mobileInAppMessage.large";
const String iamTemplateSmall = "creative.mobileInAppMessage.small";
const String iamPushNotification = "creative.pushNotification";

//const String identityTypeEmail = "email_id";
const String identityTypeLogin = "login_id";
const String identityTypeCustomerId = "customer_id";
