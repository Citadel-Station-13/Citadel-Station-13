/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const THEMES = ['light', 'dark', 'default'];

const COLORS: Record<string, {
  BG_BASE: string,
  BG_SECOND: string,
  BUTTON: string,
  TEXT: string,
}> = {
  DARK: {
    BG_BASE: '#272727',
    BG_SECOND: '#242424',
    BUTTON: '#40628A',
    TEXT: '#E0E0E0',
  },
  LIGHT: {
    BG_BASE: '#F0F0F0',
    BG_SECOND: '#E6E6E6',
    BUTTON: '#90B3DD',
    TEXT: '#000000',
  },
  // dark theme (ui) light theme (chat)
  DEFAULT: {
    BG_BASE: '#272727',
    BG_SECOND: '#242424',
    BUTTON: '#40628A',
    TEXT: "#E0E0E0",
  },
};

let setClientThemeTimer: NodeJS.Timeout;

/**
 * Darkmode preference, originally by Kmc2000.
 *
 * This lets you switch client themes by using winset.
 *
 * If you change ANYTHING in interface/skin.dmf you need to change it here.
 *
 * There's no way round it. We're essentially changing the skin by hand.
 * It's painful but it works, and is the way Lummox suggested.
 */
export const setClientTheme = (name) => {
  // Transmit once for fast updates and again in a little while in case we won
  // the race against statbrowser init.
  clearInterval(setClientThemeTimer);
  Byond.command(`.output statbrowser:set_theme ${name}`);
  setClientThemeTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_theme ${name}`);
  }, 1500);

  const themeColor = COLORS[name.toUpperCase()];
  if (!themeColor) {
    return;
  }

  return Byond.winset({
    // Main windows
    'infowindow.background-color': themeColor.BG_SECOND,
    'infowindow.text-color': themeColor.TEXT,
    'info.background-color': themeColor.BG_BASE,
    'info.text-color': themeColor.TEXT,
    'browseroutput.background-color': themeColor.BG_SECOND,
    'browseroutput.text-color': themeColor.TEXT,
    'outputwindow.background-color': themeColor.BG_SECOND,
    'outputwindow.text-color': themeColor.TEXT,
    'mainwindow.background-color': themeColor.BG_SECOND,
    'split.background-color': themeColor.BG_BASE,
    // Buttons
    'changelog.background-color': themeColor.BUTTON,
    'changelog.text-color': themeColor.TEXT,
    'rules.background-color': themeColor.BUTTON,
    'rules.text-color': themeColor.TEXT,
    'wiki.background-color': themeColor.BUTTON,
    'wiki.text-color': themeColor.TEXT,
    'forum.background-color': themeColor.BUTTON,
    'forum.text-color': themeColor.TEXT,
    'github.background-color': themeColor.BUTTON,
    'github.text-color': themeColor.TEXT,
    'report-issue.background-color': themeColor.BUTTON,
    'report-issue.text-color': themeColor.TEXT,
    // Status and verb tabs
    'output.background-color': themeColor.BG_BASE,
    'output.text-color': themeColor.TEXT,
    // Oldstat
    'statwindow.background-color': themeColor.BG_SECOND,
    'statwindow.text-color': themeColor.TEXT,
    'stat_tab.background-color': themeColor.BG_SECOND,
    'stat_tab.text-color': themeColor.TEXT,
    'statpanel.background-color': themeColor.BG_BASE,
    'statpanel.tab-background-color': themeColor.BG_SECOND,
    'statpanel.text-color': themeColor.TEXT,
    'statpanel.tab-text-color': themeColor.TEXT,
    'statpanel.prefix-color': themeColor.TEXT,
    'statpanel.suffix-color': themeColor.TEXT,
    // Say, OOC, me Buttons etc.
    'saybutton.background-color': themeColor.BG_SECOND,
    'saybutton.text-color': themeColor.TEXT,
    'asset_cache_browser.background-color': themeColor.BG_SECOND,
    'asset_cache_browser.text-color': themeColor.TEXT,
    'tooltip.background-color': themeColor.BG_BASE,
    'tooltip.text-color': themeColor.TEXT,
  });
};
