/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const THEMES = ['light', 'dark', 'default'];
/*
const COLOR_DARK_BG = '#202020';
const COLOR_DARK_BG_DARKER = '#171717';
const COLOR_DARK_TEXT = '#a4bad6';
*/
/* CIT SPECIFIC DEFINES. */
const COLOR_DARK_INFO_BUTTONS_BG = "#40628A";
const COLOR_DARK_BG = "#272727";
const COLOR_DARK_DARKBG = "#242424";
const COLOR_DARK_TEXT = "#E0E0E0";

const COLOR_WHITE_INFO_BUTTONS_BG = "#90B3DD";
const COLOR_WHITE_BG = "#F0F0F0";
const COLOR_WHITE_DARKBG = "#E6E6E6";
const COLOR_WHITE_TEXT = "#000000";

let setClientThemeTimer = null;

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
export const setClientTheme = name => {
  // Transmit once for fast updates and again in a little while in case we won
  // the race against statbrowser init.
  clearInterval(setClientThemeTimer);
  Byond.command(`.output statbrowser:set_theme ${name}`);
  setClientThemeTimer = setTimeout(() => {
    Byond.command(`.output statbrowser:set_theme ${name}`);
  }, 1500);

  if (name === 'light') {
    return Byond.winset({
      // Main windows
      'infowindow.background-color': COLOR_WHITE_DARKBG,
      'infowindow.text-color': COLOR_WHITE_TEXT,
      'info.background-color': COLOR_WHITE_BG,
      'info.text-color': COLOR_WHITE_TEXT,
      'browseroutput.background-color': COLOR_WHITE_DARKBG,
      'browseroutput.text-color': COLOR_WHITE_TEXT,
      'outputwindow.background-color': COLOR_WHITE_DARKBG,
      'outputwindow.text-color': COLOR_WHITE_TEXT,
      'mainwindow.background-color': COLOR_WHITE_DARKBG,
      'split.background-color': COLOR_WHITE_BG,
      // Buttons
      'changelog.background-color': COLOR_WHITE_INFO_BUTTONS_BG,
      'changelog.text-color': COLOR_WHITE_TEXT,
      'rules.background-color': COLOR_WHITE_INFO_BUTTONS_BG,
      'rules.text-color': COLOR_WHITE_TEXT,
      'wiki.background-color': COLOR_WHITE_INFO_BUTTONS_BG,
      'wiki.text-color': COLOR_WHITE_TEXT,
      'forum.background-color': COLOR_WHITE_INFO_BUTTONS_BG,
      'forum.text-color': COLOR_WHITE_TEXT,
      'github.background-color': COLOR_WHITE_INFO_BUTTONS_BG,
      'github.text-color': COLOR_WHITE_TEXT,
      'report-issue.background-color': '#EF7F7F',
      'report-issue.text-color': COLOR_WHITE_TEXT,
      // Status and verb tabs
      'output.background-color': COLOR_WHITE_BG,
      'output.text-color': COLOR_WHITE_TEXT,
      'statwindow.background-color': COLOR_WHITE_DARKBG,
      'statwindow.text-color': COLOR_WHITE_TEXT,
      'stat.background-color': COLOR_WHITE_BG,
      'stat.tab-background-color': COLOR_WHITE_DARKBG,
      'stat.text-color': COLOR_WHITE_TEXT,
      'stat.tab-text-color': COLOR_WHITE_TEXT,
      'stat.prefix-color': COLOR_WHITE_TEXT,
      'stat.suffix-color': COLOR_WHITE_TEXT,
      // Say, OOC, me Buttons etc.
      'saybutton.background-color': COLOR_WHITE_DARKBG,
      'saybutton.text-color': COLOR_WHITE_TEXT,
      // 'oocbutton.background-color': COLOR_WHITE_DARKBG,
      // 'oocbutton.text-color': COLOR_WHITE_TEXT,
      // 'mebutton.background-color': COLOR_WHITE_DARKBG,
      // 'mebutton.text-color': COLOR_WHITE_TEXT,
      'asset_cache_browser.background-color': COLOR_WHITE_DARKBG,
      'asset_cache_browser.text-color': COLOR_WHITE_TEXT,
      'tooltip.background-color': COLOR_WHITE_BG,
      'tooltip.text-color': COLOR_WHITE_TEXT,
    });
  }
  if (name === 'dark') {
    Byond.winset({
      // Main windows
      'infowindow.background-color': COLOR_DARK_DARKBG,
      'infowindow.text-color': COLOR_DARK_TEXT,
      'info.background-color': COLOR_DARK_BG,
      'info.text-color': COLOR_DARK_TEXT,
      'browseroutput.background-color': COLOR_DARK_BG,
      'browseroutput.text-color': COLOR_DARK_TEXT,
      'outputwindow.background-color': COLOR_DARK_BG,
      'outputwindow.text-color': COLOR_DARK_TEXT,
      'mainwindow.background-color': COLOR_DARK_DARKBG,
      'split.background-color': COLOR_DARK_BG,
      // Buttons
      'changelog.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'changelog.text-color': COLOR_DARK_TEXT,
      'rules.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'rules.text-color': COLOR_DARK_TEXT,
      'wiki.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'wiki.text-color': COLOR_DARK_TEXT,
      'forum.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'forum.text-color': COLOR_DARK_TEXT,
      'github.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'github.text-color': COLOR_DARK_TEXT,
      'report-issue.background-color': '#A92C2C',
      'report-issue.text-color': COLOR_DARK_TEXT,
      // Status and verb tabs
      'output.background-color': COLOR_DARK_BG,
      'output.text-color': COLOR_DARK_TEXT,
      'statwindow.background-color': COLOR_DARK_DARKBG,
      'statwindow.text-color': COLOR_DARK_TEXT,
      'stat.background-color': COLOR_DARK_DARKBG,
      'stat.tab-background-color': COLOR_DARK_BG,
      'stat.text-color': COLOR_DARK_TEXT,
      'stat.tab-text-color': COLOR_DARK_TEXT,
      'stat.prefix-color': COLOR_DARK_TEXT,
      'stat.suffix-color': COLOR_DARK_TEXT,
      // Say, OOC, me Buttons etc.
      'saybutton.background-color': COLOR_DARK_BG,
      'saybutton.text-color': COLOR_DARK_TEXT,
      // 'oocbutton.background-color': COLOR_DARK_BG,
      // 'oocbutton.text-color': COLOR_DARK_TEXT,
      // 'mebutton.background-color': COLOR_DARK_BG,
      // 'mebutton.text-color': COLOR_DARK_TEXT,
      'asset_cache_browser.background-color': COLOR_DARK_BG,
      'asset_cache_browser.text-color': COLOR_DARK_TEXT,
      'tooltip.background-color': COLOR_DARK_BG,
      'tooltip.text-color': COLOR_DARK_TEXT,
    });
  }
  if (name === 'default') { // white-theme (chat) BUT game is using dorktheme
    Byond.winset({
      // Main windows
      'infowindow.background-color': COLOR_DARK_DARKBG,
      'infowindow.text-color': COLOR_DARK_TEXT,
      'info.background-color': COLOR_DARK_BG,
      'info.text-color': COLOR_DARK_TEXT,
      'browseroutput.background-color': COLOR_DARK_BG,
      'browseroutput.text-color': COLOR_DARK_TEXT,
      'outputwindow.background-color': COLOR_DARK_BG,
      'outputwindow.text-color': COLOR_DARK_TEXT,
      'mainwindow.background-color': COLOR_DARK_DARKBG,
      'split.background-color': COLOR_DARK_BG,
      // Buttons
      'changelog.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'changelog.text-color': COLOR_DARK_TEXT,
      'rules.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'rules.text-color': COLOR_DARK_TEXT,
      'wiki.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'wiki.text-color': COLOR_DARK_TEXT,
      'forum.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'forum.text-color': COLOR_DARK_TEXT,
      'github.background-color': COLOR_DARK_INFO_BUTTONS_BG,
      'github.text-color': COLOR_DARK_TEXT,
      'report-issue.background-color': '#A92C2C',
      'report-issue.text-color': COLOR_DARK_TEXT,
      // Status and verb tabs
      'output.background-color': COLOR_DARK_BG,
      'output.text-color': COLOR_DARK_TEXT,
      'statwindow.background-color': COLOR_DARK_DARKBG,
      'statwindow.text-color': COLOR_DARK_TEXT,
      'stat.background-color': COLOR_DARK_DARKBG,
      'stat.tab-background-color': COLOR_DARK_BG,
      'stat.text-color': COLOR_DARK_TEXT,
      'stat.tab-text-color': COLOR_DARK_TEXT,
      'stat.prefix-color': COLOR_DARK_TEXT,
      'stat.suffix-color': COLOR_DARK_TEXT,
      // Say, OOC, me Buttons etc.
      'saybutton.background-color': COLOR_DARK_BG,
      'saybutton.text-color': COLOR_DARK_TEXT,
      // 'oocbutton.background-color': COLOR_DARK_BG,
      // 'oocbutton.text-color': COLOR_DARK_TEXT,
      // 'mebutton.background-color': COLOR_DARK_BG,
      // 'mebutton.text-color': COLOR_DARK_TEXT,
      'asset_cache_browser.background-color': COLOR_DARK_BG,
      'asset_cache_browser.text-color': COLOR_DARK_TEXT,
      'tooltip.background-color': COLOR_DARK_BG,
      'tooltip.text-color': COLOR_DARK_TEXT,
    });
  }
};
