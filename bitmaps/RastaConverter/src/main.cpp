#ifdef USE_ALLEGRO
#include <allegro.h> 
#else
#ifdef WIN32
#define WIN32_LEAN_AND_MEAN
#define BITMAP WBITMAP
#include <Windows.h>
#include <ShellAPI.h>
#undef BITMAP
#include <stdlib.h>
int main(int argc, char *argv[]);
int CALLBACK WinMain(
  __in  HINSTANCE hInstance,
  __in  HINSTANCE hPrevInstance,
  __in  LPSTR lpCmdLine,
  __in  int nCmdShow
)
{
	main(__argc, __argv);
}
#endif
#include <time.h>
#endif
#include "rasta.h"

extern bool quiet;
int screen_color_depth;
int desktop_width;
int desktop_height;

void quit_function(void);
void close_button_procedure();

bool LoadAtariPalette(string filename);
void create_cycles_table();

int main(int argc, char *argv[])
{
#ifdef USE_ALLEGRO
	//////////////////////////////////////////////////////////////////////////
	allegro_init(); // Initialize Allegro
	install_keyboard();
	set_close_button_callback(quit_function);
#endif
	FreeImage_Initialise(TRUE);

	create_cycles_table();

	Configuration cfg;
	cfg.Process(argc, argv);

	RastaConverter rasta;
	if (cfg.continue_processing)
	{
		quiet=true;
		rasta.Resume1();
		rasta.cfg.continue_processing=true;
		quiet=false;
	}
	else
		rasta.SetConfig(cfg);

#ifdef USE_ALLEGRO
	set_window_title(rasta.cfg.command_line.c_str());
	screen_color_depth = desktop_color_depth();
	get_desktop_resolution(&desktop_width,&desktop_height);
	set_color_depth(screen_color_depth);

	if (!rasta.cfg.preprocess_only)
	{
		if (desktop_width>=320*3)
			set_gfx_mode(GFX_AUTODETECT_WINDOWED, 320*3,480,0,0); 
		else
			set_gfx_mode(GFX_AUTODETECT_WINDOWED, 640, 480,0,0); // Change our graphics mode to 640x480

		set_display_switch_mode(SWITCH_BACKGROUND);
		set_close_button_callback(close_button_procedure);

		set_window_title(rasta.cfg.command_line.c_str());
	}
	else
		quiet=true;
#endif
	LoadAtariPalette(rasta.cfg.palette_file);

	rasta.LoadInputBitmap();
	if (rasta.ProcessInit())
	{
		rasta.FindBestSolution();
		rasta.SaveBestSolution();
	}
	return 0; // Exit with no errors
}


#ifdef USE_ALLEGRO
END_OF_MAIN() // This must be called right after the closing bracket of your MAIN function.
// It is Allegro specific.
#endif
