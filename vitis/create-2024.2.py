import _env
import vitis
import traceback
import logging
import os

client = None
try:
    client = vitis.create_client()
    client.set_workspace(path=_env.MB_VITIS_OUT_DIR)
    platform = client.create_platform_component(
        name=_env.MB_VITIS_PLATFORM_OPT,
        hw_design=_env.MB_VIVADO_XSA_FP,
        os='standalone',
        cpu='ps7_cortexa9_0')

    app = client.create_app_component(
        name=_env.MB_VITIS_APP_OPT,
        platform=_env.MB_VITIS_XPFM_FP,
        domain='standalone_ps7_cortexa9_0',
        template=_env.MB_VITIS_APP_PYTHON_TEMPLATE_OPT)

    app.import_files(
        from_loc=_env.MB_VITIS_PROJ_SRC_PATH,
        files=os.listdir(_env.MB_VITIS_PROJ_SRC_PATH),
        dest_dir_in_cmp=_env.MB_VITIS_APP_SRC_PATH)

    status = platform.build()

except Exception as e:
    logging.error(traceback.format_exc())

client.close()
