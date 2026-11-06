import _env
import vitis
import traceback
import logging

client = None
try:
    client = vitis.create_client()
    client.set_workspace(path=_env.MB_VITIS_OUT_DIR)
    platform = platform = client.get_platform_component(name=_env.MB_VITIS_PLATFORM_OPT)
    status = platform.build()
    app = client.get_component(name=_env.MB_VITIS_APP_OPT)
    status = app.build()
except Exception as e:
    logging.error(traceback.format_exc())

client.close()
