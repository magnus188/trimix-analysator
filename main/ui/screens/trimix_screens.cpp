// Screen management (C++). Moved to ui/screens.
#include "trimix_screens.h"
#include "sensors/sensor_interface.h"
#include <esp_log.h>
#include <esp_timer.h>
#include <array>

namespace {
static const char *TAG = "SCREENS";

#define COLOR_PRIMARY lv_color_hex(0x2196F3)
#define COLOR_SECONDARY lv_color_hex(0x4CAF50)
#define COLOR_DANGER lv_color_hex(0xF44336)
#define COLOR_WARNING lv_color_hex(0xFF9800)
#define COLOR_BACKGROUND lv_color_hex(0x121212)

static lv_obj_t *create_home_screen(void);
static lv_obj_t *create_analyze_screen(void);
static lv_obj_t *create_dive_planner_screen(void);
static lv_obj_t *create_history_screen(void);
static lv_obj_t *create_settings_screen(void);
static lv_obj_t *create_calibrate_o2_screen(void);
static lv_obj_t *create_navbar(lv_obj_t *parent);
static void sensor_update_callback(void *arg);

static void event_go_home(lv_event_t *e); static void event_go_analyze(lv_event_t *e); static void event_go_dive_planner(lv_event_t *e); static void event_go_history(lv_event_t *e); static void event_go_settings(lv_event_t *e); static void event_go_calibrate_o2(lv_event_t *e); static void event_do_o2_calibration(lv_event_t *e); static void event_back_to_settings(lv_event_t *e);

class ScreenManager {
public:
    static ScreenManager &instance(){ static ScreenManager mgr; return mgr; }
    void init(){
        ESP_LOGI(TAG, "Initializing screens (C++)");
        screens_[SCREEN_HOME] = create_home_screen();
        screens_[SCREEN_ANALYZE] = create_analyze_screen();
    screens_[SCREEN_DIVE_PLANNER] = create_dive_planner_screen();
    screens_[SCREEN_HISTORY] = create_history_screen();
    screens_[SCREEN_SETTINGS] = create_settings_screen();
        screens_[SCREEN_CALIBRATE_O2] = create_calibrate_o2_screen();
        show(SCREEN_HOME);
        const esp_timer_create_args_t timer_args = { .callback=&sensor_update_callback, .arg=nullptr, .dispatch_method=ESP_TIMER_TASK, .name="sensor_update", .skip_unhandled_events=true };
        esp_timer_create(&timer_args, &sensor_update_timer_);
        esp_timer_start_periodic(sensor_update_timer_, 2000000);
    }
        void show(screen_id_t id){ if(id>=SCREEN_COUNT){ ESP_LOGE(TAG,"Invalid screen %d", id); return;} current_screen_ = id; lv_scr_load(screens_[id]); }
    screen_id_t current() const { return current_screen_; }
    void update_analyze(){ if(!label_o2_||!label_co2_||!label_temp_||!label_pressure_||!label_humidity_) return; sensor_readings_t r{}; if(sensor_read_all(&r)==ESP_OK){ lv_label_set_text_fmt(label_o2_,"%.1f %%", r.oxygen_percent); lv_label_set_text_fmt(label_co2_,"%.0f ppm", r.co2_ppm); lv_label_set_text_fmt(label_temp_,"%.1f °C", r.temperature_c); lv_label_set_text_fmt(label_pressure_,"%.2f bar", r.pressure_bar); lv_label_set_text_fmt(label_humidity_,"%.1f %%", r.humidity_pct);} }
    bool analyze_active() const { return current_screen_==SCREEN_ANALYZE; }
    void set_label_o2(lv_obj_t *o){ label_o2_=o;} void set_label_co2(lv_obj_t *o){ label_co2_=o;} void set_label_temp(lv_obj_t *o){ label_temp_=o;} void set_label_pressure(lv_obj_t *o){ label_pressure_=o;} void set_label_humidity(lv_obj_t *o){ label_humidity_=o; }
private:
    std::array<lv_obj_t*, SCREEN_COUNT> screens_{};
    screen_id_t current_screen_ = SCREEN_HOME;
    lv_obj_t *label_o2_ = nullptr, *label_co2_ = nullptr, *label_temp_ = nullptr, *label_pressure_ = nullptr, *label_humidity_ = nullptr; esp_timer_handle_t sensor_update_timer_{};
};
static inline ScreenManager &M(){ return ScreenManager::instance(); }

static void event_go_home(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_home(); }
static void event_go_analyze(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_analyze(); }
static void event_go_settings(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_settings(); }
static void event_go_dive_planner(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_dive_planner(); }
static void event_go_history(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_history(); }
static void event_go_calibrate_o2(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_calibrate_o2(); }
static void event_back_to_settings(lv_event_t *e){ if(lv_event_get_code(e)==LV_EVENT_CLICKED) navigate_to_settings(); }
static void event_do_o2_calibration(lv_event_t *e){ if(lv_event_get_code(e)!=LV_EVENT_CLICKED) return; if(sensor_calibrate_oxygen_air()==ESP_OK){ lv_obj_t *msg = lv_label_create(lv_scr_act()); lv_label_set_text(msg, "Calibration Complete!"); lv_obj_set_style_text_color(msg, COLOR_SECONDARY,0); lv_obj_align(msg, LV_ALIGN_CENTER, 0, 120);} }

static lv_obj_t *create_navbar(lv_obj_t *parent){ lv_obj_t *navbar = lv_obj_create(parent); lv_obj_set_size(navbar, LV_PCT(100), 60); lv_obj_align(navbar, LV_ALIGN_BOTTOM_MID,0,0); lv_obj_set_style_bg_color(navbar, COLOR_PRIMARY,0); lv_obj_set_style_border_width(navbar,0,0); lv_obj_set_style_radius(navbar,0,0); lv_obj_clear_flag(navbar, LV_OBJ_FLAG_SCROLLABLE); lv_obj_set_scrollbar_mode(navbar, LV_SCROLLBAR_MODE_OFF); lv_obj_set_scroll_dir(navbar, LV_DIR_NONE); lv_obj_t *btn_home=lv_btn_create(navbar); lv_obj_set_size(btn_home,80,40); lv_obj_align(btn_home, LV_ALIGN_LEFT_MID,10,0); lv_obj_add_event_cb(btn_home,event_go_home, LV_EVENT_CLICKED,nullptr); lv_obj_t *label_home=lv_label_create(btn_home); lv_label_set_text(label_home,"Home"); lv_obj_center(label_home); lv_obj_t *btn_analyze=lv_btn_create(navbar); lv_obj_set_size(btn_analyze,80,40); lv_obj_align(btn_analyze, LV_ALIGN_CENTER,0,0); lv_obj_add_event_cb(btn_analyze,event_go_analyze, LV_EVENT_CLICKED,nullptr); lv_obj_t *label_analyze=lv_label_create(btn_analyze); lv_label_set_text(label_analyze,"Analyze"); lv_obj_center(label_analyze); lv_obj_t *btn_settings=lv_btn_create(navbar); lv_obj_set_size(btn_settings,80,40); lv_obj_align(btn_settings, LV_ALIGN_RIGHT_MID,-10,0); lv_obj_add_event_cb(btn_settings,event_go_settings, LV_EVENT_CLICKED,nullptr); lv_obj_t *label_settings=lv_label_create(btn_settings); lv_label_set_text(label_settings,"Settings"); lv_obj_center(label_settings); return navbar; }

static lv_obj_t *create_home_screen(void){
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    // Title
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Trimix Analyzer");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 15);
    // Grid container for 2x2 buttons
    lv_obj_t *grid = lv_obj_create(screen);
    lv_obj_set_size(grid, LV_PCT(90), 360);
    lv_obj_align(grid, LV_ALIGN_CENTER, 0, 10);
    lv_obj_set_style_bg_opa(grid, LV_OPA_TRANSP, 0);
    lv_obj_set_style_border_width(grid, 0, 0);
    lv_obj_set_layout(grid, LV_LAYOUT_GRID);
    static int32_t col_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    static int32_t row_dsc[] = { LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST };
    lv_obj_set_grid_dsc_array(grid, col_dsc, row_dsc);
    auto make_btn = [&](const char *txt, int col, int row, lv_event_cb_t cb){
        lv_obj_t *btn = lv_btn_create(grid);
        lv_obj_set_grid_cell(btn, LV_GRID_ALIGN_STRETCH, col, 1, LV_GRID_ALIGN_STRETCH, row, 1);
        lv_obj_set_style_radius(btn, 12, 0);
        lv_obj_set_style_bg_color(btn, COLOR_PRIMARY, 0);
        lv_obj_set_style_bg_opa(btn, LV_OPA_COVER, 0);
        lv_obj_add_event_cb(btn, cb, LV_EVENT_CLICKED, nullptr);
        lv_obj_t *label = lv_label_create(btn);
        lv_label_set_text(label, txt);
        lv_obj_set_style_text_font(label, &lv_font_montserrat_14, 0);
        lv_obj_center(label);
        return btn;
    };
    make_btn("Analyze", 0, 0, event_go_analyze);
    make_btn("Dive Planner", 1, 0, event_go_dive_planner);
    make_btn("History", 0, 1, event_go_history);
    make_btn("Settings", 1, 1, event_go_settings);
    return screen;
}

static lv_obj_t *create_dive_planner_screen(void){
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "Dive Planner");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    lv_obj_t *info = lv_label_create(screen);
    lv_label_set_text(info, "(Coming soon) Plan your dive profiles here.");
    lv_obj_set_style_text_color(info, lv_color_white(), 0);
    lv_obj_align(info, LV_ALIGN_CENTER, 0, 0);
    create_navbar(screen);
    return screen;
}

static lv_obj_t *create_history_screen(void){
    lv_obj_t *screen = lv_obj_create(NULL);
    lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND, 0);
    lv_obj_t *title = lv_label_create(screen);
    lv_label_set_text(title, "History");
    lv_obj_set_style_text_font(title, &lv_font_montserrat_14, 0);
    lv_obj_set_style_text_color(title, lv_color_white(), 0);
    lv_obj_align(title, LV_ALIGN_TOP_MID, 0, 10);
    lv_obj_t *info = lv_label_create(screen);
    lv_label_set_text(info, "(Coming soon) View previous analyses.");
    lv_obj_set_style_text_color(info, lv_color_white(), 0);
    lv_obj_align(info, LV_ALIGN_CENTER, 0, 0);
    create_navbar(screen);
    return screen;
}

static lv_obj_t *create_analyze_screen(void){ auto &mgr=M(); lv_obj_t *screen=lv_obj_create(NULL); lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND,0); lv_obj_t *title=lv_label_create(screen); lv_label_set_text(title,"Real-time Analysis"); lv_obj_set_style_text_font(title,&lv_font_montserrat_14,0); lv_obj_set_style_text_color(title, lv_color_white(),0); lv_obj_align(title, LV_ALIGN_TOP_MID,0,10); lv_obj_t *grid_container=lv_obj_create(screen); lv_obj_set_size(grid_container, LV_PCT(90),600); lv_obj_align(grid_container, LV_ALIGN_CENTER,0,20); lv_obj_set_style_bg_opa(grid_container, LV_OPA_TRANSP,0); lv_obj_set_style_border_width(grid_container,0,0); lv_obj_set_layout(grid_container, LV_LAYOUT_GRID); static int32_t col_dsc[]={LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST}; static int32_t row_dsc[]={LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_FR(1), LV_GRID_TEMPLATE_LAST}; lv_obj_set_grid_dsc_array(grid_container, col_dsc,row_dsc); lv_obj_t *o2_card=lv_obj_create(grid_container); lv_obj_set_grid_cell(o2_card, LV_GRID_ALIGN_STRETCH,0,1, LV_GRID_ALIGN_STRETCH,0,1); lv_obj_set_style_bg_color(o2_card, COLOR_SECONDARY,0); lv_obj_set_style_border_width(o2_card,2,0); lv_obj_set_style_border_color(o2_card, lv_color_white(),0); lv_obj_set_style_radius(o2_card,10,0); lv_obj_t *o2_title=lv_label_create(o2_card); lv_label_set_text(o2_title,"Oxygen"); lv_obj_set_style_text_color(o2_title, lv_color_white(),0); lv_obj_align(o2_title, LV_ALIGN_TOP_MID,0,5); lv_obj_t *label_o2=lv_label_create(o2_card); lv_label_set_text(label_o2,"20.9 %"); lv_obj_set_style_text_color(label_o2, lv_color_white(),0); lv_obj_set_style_text_font(label_o2,&lv_font_montserrat_14,0); lv_obj_align(label_o2, LV_ALIGN_CENTER,0,5); mgr.set_label_o2(label_o2); lv_obj_t *co2_card=lv_obj_create(grid_container); lv_obj_set_grid_cell(co2_card, LV_GRID_ALIGN_STRETCH,1,1, LV_GRID_ALIGN_STRETCH,0,1); lv_obj_set_style_bg_color(co2_card, COLOR_WARNING,0); lv_obj_set_style_border_width(co2_card,2,0); lv_obj_set_style_border_color(co2_card, lv_color_white(),0); lv_obj_set_style_radius(co2_card,10,0); lv_obj_t *co2_title=lv_label_create(co2_card); lv_label_set_text(co2_title,"CO2"); lv_obj_set_style_text_color(co2_title, lv_color_white(),0); lv_obj_align(co2_title, LV_ALIGN_TOP_MID,0,5); lv_obj_t *label_co2=lv_label_create(co2_card); lv_label_set_text(label_co2,"400 ppm"); lv_obj_set_style_text_color(label_co2, lv_color_white(),0); lv_obj_set_style_text_font(label_co2,&lv_font_montserrat_14,0); lv_obj_align(label_co2, LV_ALIGN_CENTER,0,5); mgr.set_label_co2(label_co2); lv_obj_t *temp_card=lv_obj_create(grid_container); lv_obj_set_grid_cell(temp_card, LV_GRID_ALIGN_STRETCH,0,1, LV_GRID_ALIGN_STRETCH,1,1); lv_obj_set_style_bg_color(temp_card, COLOR_PRIMARY,0); lv_obj_set_style_border_width(temp_card,2,0); lv_obj_set_style_border_color(temp_card, lv_color_white(),0); lv_obj_set_style_radius(temp_card,10,0); lv_obj_t *temp_title=lv_label_create(temp_card); lv_label_set_text(temp_title,"Temperature"); lv_obj_set_style_text_color(temp_title, lv_color_white(),0); lv_obj_align(temp_title, LV_ALIGN_TOP_MID,0,5); lv_obj_t *label_temp=lv_label_create(temp_card); lv_label_set_text(label_temp,"22.5 °C"); lv_obj_set_style_text_color(label_temp, lv_color_white(),0); lv_obj_set_style_text_font(label_temp,&lv_font_montserrat_14,0); lv_obj_align(label_temp, LV_ALIGN_CENTER,0,5); mgr.set_label_temp(label_temp); lv_obj_t *press_card=lv_obj_create(grid_container); lv_obj_set_grid_cell(press_card, LV_GRID_ALIGN_STRETCH,1,1, LV_GRID_ALIGN_STRETCH,1,1); lv_obj_set_style_bg_color(press_card, COLOR_PRIMARY,0); lv_obj_set_style_border_width(press_card,2,0); lv_obj_set_style_border_color(press_card, lv_color_white(),0); lv_obj_set_style_radius(press_card,10,0); lv_obj_t *press_title=lv_label_create(press_card); lv_label_set_text(press_title,"Pressure"); lv_obj_set_style_text_color(press_title, lv_color_white(),0); lv_obj_align(press_title, LV_ALIGN_TOP_MID,0,5); lv_obj_t *label_pressure=lv_label_create(press_card); lv_label_set_text(label_pressure,"1.01 bar"); lv_obj_set_style_text_color(label_pressure, lv_color_white(),0); lv_obj_set_style_text_font(label_pressure,&lv_font_montserrat_14,0); lv_obj_align(label_pressure, LV_ALIGN_CENTER,0,5); mgr.set_label_pressure(label_pressure); lv_obj_t *hum_card=lv_obj_create(grid_container); lv_obj_set_grid_cell(hum_card, LV_GRID_ALIGN_STRETCH,0,2, LV_GRID_ALIGN_STRETCH,2,1); lv_obj_set_style_bg_color(hum_card, COLOR_PRIMARY,0); lv_obj_set_style_border_width(hum_card,2,0); lv_obj_set_style_border_color(hum_card, lv_color_white(),0); lv_obj_set_style_radius(hum_card,10,0); lv_obj_t *hum_title=lv_label_create(hum_card); lv_label_set_text(hum_title,"Humidity"); lv_obj_set_style_text_color(hum_title, lv_color_white(),0); lv_obj_align(hum_title, LV_ALIGN_TOP_MID,0,5); lv_obj_t *label_humidity=lv_label_create(hum_card); lv_label_set_text(label_humidity,"45.2 %"); lv_obj_set_style_text_color(label_humidity, lv_color_white(),0); lv_obj_set_style_text_font(label_humidity,&lv_font_montserrat_14,0); lv_obj_align(label_humidity, LV_ALIGN_CENTER,0,5); mgr.set_label_humidity(label_humidity); create_navbar(screen); return screen; }

static lv_obj_t *create_settings_screen(void){ lv_obj_t *screen=lv_obj_create(NULL); lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND,0); lv_obj_t *title=lv_label_create(screen); lv_label_set_text(title,"Settings"); lv_obj_set_style_text_font(title,&lv_font_montserrat_14,0); lv_obj_set_style_text_color(title, lv_color_white(),0); lv_obj_align(title, LV_ALIGN_TOP_MID,0,10); lv_obj_t *menu_container=lv_obj_create(screen); lv_obj_set_size(menu_container, LV_PCT(85),450); lv_obj_center(menu_container); lv_obj_set_style_bg_opa(menu_container, LV_OPA_TRANSP,0); lv_obj_set_style_border_width(menu_container,0,0); lv_obj_set_flex_flow(menu_container, LV_FLEX_FLOW_COLUMN); lv_obj_set_style_pad_gap(menu_container,20,0); lv_obj_t *btn_calibrate=lv_btn_create(menu_container); lv_obj_set_size(btn_calibrate, LV_PCT(100),60); lv_obj_set_style_bg_color(btn_calibrate, COLOR_SECONDARY,0); lv_obj_add_event_cb(btn_calibrate,event_go_calibrate_o2, LV_EVENT_CLICKED,nullptr); lv_obj_t *calibrate_label=lv_label_create(btn_calibrate); lv_label_set_text(calibrate_label,"O2 Sensor Calibration"); lv_obj_set_style_text_font(calibrate_label,&lv_font_montserrat_14,0); lv_obj_center(calibrate_label); lv_obj_t *btn_sysinfo=lv_btn_create(menu_container); lv_obj_set_size(btn_sysinfo, LV_PCT(100),60); lv_obj_set_style_bg_color(btn_sysinfo, COLOR_PRIMARY,0); lv_obj_t *sysinfo_label=lv_label_create(btn_sysinfo); lv_label_set_text(sysinfo_label,"System Information"); lv_obj_set_style_text_font(sysinfo_label,&lv_font_montserrat_14,0); lv_obj_center(sysinfo_label); lv_obj_t *btn_about=lv_btn_create(menu_container); lv_obj_set_size(btn_about, LV_PCT(100),60); lv_obj_set_style_bg_color(btn_about, COLOR_PRIMARY,0); lv_obj_t *about_label=lv_label_create(btn_about); lv_label_set_text(about_label,"About"); lv_obj_set_style_text_font(about_label,&lv_font_montserrat_14,0); lv_obj_center(about_label); create_navbar(screen); return screen; }

static lv_obj_t *create_calibrate_o2_screen(void){ lv_obj_t *screen=lv_obj_create(NULL); lv_obj_set_style_bg_color(screen, COLOR_BACKGROUND,0); lv_obj_t *title=lv_label_create(screen); lv_label_set_text(title,"O2 Calibration"); lv_obj_set_style_text_font(title,&lv_font_montserrat_14,0); lv_obj_set_style_text_color(title, lv_color_white(),0); lv_obj_align(title, LV_ALIGN_TOP_MID,0,10); lv_obj_t *instructions=lv_label_create(screen); lv_label_set_text(instructions,"1. Ensure sensor is exposed to normal air\n2. Wait for readings to stabilize\n3. Press 'Calibrate' to set 20.9% O2"); lv_obj_set_style_text_color(instructions, lv_color_white(),0); lv_obj_set_style_text_align(instructions, LV_TEXT_ALIGN_CENTER,0); lv_obj_align(instructions, LV_ALIGN_CENTER,0,-60); lv_obj_t *current_reading=lv_label_create(screen); lv_label_set_text(current_reading,"Current: 20.9% O2"); lv_obj_set_style_text_font(current_reading,&lv_font_montserrat_14,0); lv_obj_set_style_text_color(current_reading, COLOR_SECONDARY,0); lv_obj_align(current_reading, LV_ALIGN_CENTER,0,0); lv_obj_t *btn_calibrate=lv_btn_create(screen); lv_obj_set_size(btn_calibrate,200,60); lv_obj_align(btn_calibrate, LV_ALIGN_CENTER,0,60); lv_obj_set_style_bg_color(btn_calibrate, COLOR_SECONDARY,0); lv_obj_add_event_cb(btn_calibrate,event_do_o2_calibration, LV_EVENT_CLICKED,nullptr); lv_obj_t *calibrate_label=lv_label_create(btn_calibrate); lv_label_set_text(calibrate_label,"Calibrate Now"); lv_obj_set_style_text_font(calibrate_label,&lv_font_montserrat_14,0); lv_obj_center(calibrate_label); lv_obj_t *btn_back=lv_btn_create(screen); lv_obj_set_size(btn_back,100,40); lv_obj_align(btn_back, LV_ALIGN_BOTTOM_LEFT,10,-10); lv_obj_set_style_bg_color(btn_back, COLOR_PRIMARY,0); lv_obj_add_event_cb(btn_back,event_back_to_settings, LV_EVENT_CLICKED,nullptr); lv_obj_t *back_label=lv_label_create(btn_back); lv_label_set_text(back_label,"Back"); lv_obj_center(back_label); return screen; }

static void sensor_update_callback(void * /*arg*/){ if(M().analyze_active()) M().update_analyze(); }
} // namespace

extern "C" {
void screens_init(void){ M().init(); }
void screen_manager_show(screen_id_t s){ M().show(s); }
screen_id_t screen_manager_current(void){ return M().current(); }
void update_analyze_screen(void){ M().update_analyze(); }
void navigate_to_home(void){ screen_manager_show(SCREEN_HOME);} void navigate_to_analyze(void){ screen_manager_show(SCREEN_ANALYZE);} void navigate_to_dive_planner(void){ screen_manager_show(SCREEN_DIVE_PLANNER);} void navigate_to_history(void){ screen_manager_show(SCREEN_HISTORY);} void navigate_to_settings(void){ screen_manager_show(SCREEN_SETTINGS);} void navigate_to_calibrate_o2(void){ screen_manager_show(SCREEN_CALIBRATE_O2);} 
}
