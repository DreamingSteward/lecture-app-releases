# dmgbuild 설정 (GitHub Actions 의 맥에서 실행) · -D app=… -D uninst=… -D readme=… -D bg=…
import os.path, unicodedata
files = [defines["app"], defines["uninst"], (defines["readme"], "읽어 주세요.txt")]
symlinks = {"응용 프로그램": "/Applications"}
format = "UDZO"
filesystem = "HFS+"
background = defines["bg"]
window_rect = ((200, 120), (640, 480))
icon_size = 96
text_size = 12
show_status_bar = show_tab_view = show_toolbar = show_pathbar = show_sidebar = False
default_view = "icon-view"
arrange_by = None
_loc = {
    os.path.basename(defines["app"]): (170, 165),
    "응용 프로그램": (470, 165),
    "읽어 주세요.txt": (230, 380),
    os.path.basename(defines["uninst"]): (410, 380),
}
icon_locations = {}
for k, v in _loc.items():          # 한글 이름: Finder가 쓰는 모양(NFD)과 NFC 둘 다
    icon_locations[unicodedata.normalize("NFC", k)] = v
    icon_locations[unicodedata.normalize("NFD", k)] = v
