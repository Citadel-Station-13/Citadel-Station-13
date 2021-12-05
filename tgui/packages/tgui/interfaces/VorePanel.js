/* eslint-disable max-len */
import { round } from 'common/math';
import { capitalize } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, ByondUi, Flex, Collapsible, Icon, LabeledList, NoticeBox, Section, Tabs } from "../components";
import { Window } from "../layouts";
import { classes } from 'common/react';

const stats = [
  null,
  'average',
  'bad',
];

const digestModeToColor = {
  "Hold": null,
  "Dragon": "blue",
  "Digest": "red",
  "Absorb": "purple",
  "Unabsorb": "purple",
};

const digestModeToPreyMode = {
  "Hold": "being held.",
  "Digest": "being digested.",
  "Absorb": "being absorbed.",
  "Unabsorb": "being unabsorbed.",
  "Dragon": "being digested by a powerful creature.",
};

/**
 * There are three main sections to this UI.
 *  - The Inside Panel, where all relevant data for interacting with a belly you're in is located.
 *  - The Belly Selection Panel, where you can select what belly people will go into and customize the active one.
 *  - User Preferences, where you can adjust all of your vore preferences on the fly.
 */
export const VorePanel = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={700} height={660} theme="abstract" resizable>
      <Window.Content scrollable>
        {data.unsaved_changes && (
          <NoticeBox danger>
            <Flex>
              <Flex.Item basis="90%">
                Warning: Unsaved Changes!
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Save Prefs"
                  icon="save"
                  onClick={() => act("saveprefs")} />
              </Flex.Item>
            </Flex>
          </NoticeBox>
        ) || null}
        <VoreInsidePanel />
        <VoreBellySelectionAndCustomization />
        <VoreUserPreferences />
      </Window.Content>
    </Window>
  );
};

const VoreInsidePanel = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    absorbed,
    belly_name,
    belly_mode,
    desc,
    pred,
    contents,
    ref,
  } = data.inside;

  if (!belly_name) {
    return (
      <Section title="Inside">
        You aren&apos;t inside anyone.
      </Section>
    );
  }

  return (
    <Section title="Inside">
      <Box color="green" inline>You are currently {absorbed ? "absorbed into" : "inside"}</Box>&nbsp;
      <Box color="yellow" inline>{pred}&apos;s</Box>&nbsp;
      <Box color="red" inline>{belly_name}</Box>&nbsp;
      <Box color="yellow" inline>and you are</Box>&nbsp;
      <Box color={digestModeToColor[belly_mode]} inline>{digestModeToPreyMode[belly_mode]}</Box>&nbsp;
      <Box color="label">
        {desc}
      </Box>
      {contents.length && (
        <Collapsible title="Belly Contents">
          <VoreContentsPanel contents={contents} belly={ref} />
        </Collapsible>
      ) || "There is nothing else around you."}
    </Section>
  );
};

const VoreBellySelectionAndCustomization = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    our_bellies,
    selected,
  } = data;

  return (
    <Section title="My Bellies">
      <Tabs>
        {our_bellies.map(belly => (
          <Tabs.Tab
            key={belly.name}
            selected={belly.selected}
            textColor={digestModeToColor[belly.digest_mode]}
            onClick={() => act("bellypick", { bellypick: belly.ref })}>
            <Box inline textColor={belly.selected && digestModeToColor[belly.digest_mode] || null}>
              {belly.name} ({belly.contents})
            </Box>
          </Tabs.Tab>
        ))}
        <Tabs.Tab onClick={() => act("newbelly")}>
          New
          <Icon name="plus" ml={0.5} />
        </Tabs.Tab>
      </Tabs>
      {selected && <VoreSelectedBelly belly={selected} />}
    </Section>
  );
};

/**
 * Subtemplate of VoreBellySelectionAndCustomization
 */
const VoreSelectedBelly = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const { contents } = belly;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  const tabs = [];

  tabs[0] = (
    <VoreSelectedBellyControls belly={belly} />
  );

  tabs[1] = (
    <VoreSelectedBellyOptions belly={belly} />
  );

  tabs[2] = (
    <VoreContentsPanel outside contents={contents} />
  );

  tabs[3] = (
    <VoreSelectedBellyInteractions belly={belly} />
  );

  tabs[4] = (
    <VoreSelectedBellyStyles belly={belly} />
  );

  tabs[5] = (
    <VoreSelectedBellyLiquidOptions belly={belly} />
  );

  tabs[6] = (
    <VoreSelectedBellyLiquidMessages belly={belly} />
  );

  return (
    <Fragment>
      <Tabs>
        <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
          Controls
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
          Options
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
          Contents ({contents.length})
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
          Interactions
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
          Belly Styles
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 5} onClick={() => setTabIndex(5)}>
          Liquid Options
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 6} onClick={() => setTabIndex(6)}>
          Liquid Messages
        </Tabs.Tab>
      </Tabs>
      {tabs[tabIndex] || "Error"}
    </Fragment>
  );
};

const VoreSelectedBellyControls = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    belly_name,
    mode,
    item_mode,
    verb,
    desc,
    addons,
  } = belly;

  return (
    <LabeledList>
      <LabeledList.Item label="Name" buttons={
        <Fragment>
          <Button
            icon="arrow-left"
            tooltipPosition="left"
            tooltip="Move this belly tab left."
            onClick={() => act("move_belly", { dir: -1 })} />
          <Button
            icon="arrow-right"
            tooltipPosition="left"
            tooltip="Move this belly tab right."
            onClick={() => act("move_belly", { dir: 1 })} />
        </Fragment>
      }>
        <Button
          onClick={() => act("set_attribute", { attribute: "b_name" })}
          content={belly_name} />
      </LabeledList.Item>
      <LabeledList.Item label="Mode">
        <Button
          color={digestModeToColor[mode]}
          onClick={() => act("set_attribute", { attribute: "b_mode" })}
          content={mode} />
      </LabeledList.Item>
      <LabeledList.Item label="Flavor Text" buttons={
        <Button
          onClick={() => act("set_attribute", { attribute: "b_desc" })}
          icon="pen" />
      }>
        {desc}
      </LabeledList.Item>
      <LabeledList.Item label="Mode Addons">
        {addons.length && addons.join(", ") || "None"}
        <Button
          onClick={() => act("set_attribute", { attribute: "b_addons" })}
          ml={1}
          icon="plus" />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mode">
        <Button
          onClick={() => act("set_attribute", { attribute: "b_item_mode" })}
          content={item_mode} />
      </LabeledList.Item>
      <LabeledList.Item label="Vore Verb">
        <Button
          onClick={() => act("set_attribute", { attribute: "b_verb" })}
          content={verb} />
      </LabeledList.Item>
      <LabeledList.Item label="Belly Messages">
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "dmp" })}
          content="Digest Message (to prey)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "dmo" })}
          content="Digest Message (to you)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "smo" })}
          content="Struggle Message (outside)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "smi" })}
          content="Struggle Message (inside)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "em" })}
          content="Examine Message (when full)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "ema" })}
          content="Examine Message (with absorbed victims)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_hold" })}
          content="Idle Messages (Hold)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_digest" })}
          content="Idle Messages (Digest)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_absorb" })}
          content="Idle Messages (Absorb)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_unabsorb" })}
          content="Idle Messages (Unabsorb)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_drain" })}
          content="Idle Messages (Drain)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_heal" })}
          content="Idle Messages (Heal)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_steal" })}
          content="Idle Messages (Size Steal)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_shrink" })}
          content="Idle Messages (Shrink)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_grow" })}
          content="Idle Messages (Grow)" />
        <Button
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "im_egg" })}
          content="Idle Messages (Encase In Egg)" />
        <Button
          color="red"
          onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "reset" })}
          content="Reset Messages" />
      </LabeledList.Item>
    </LabeledList>
  );
};

const VoreSelectedBellyOptions = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    is_wet,
    wet_loop,
    fancy,
    sound,
    release_sound,
    can_taste,
    nutrition_percent,
    digest_brute,
    digest_burn,
    digest_oxy,
    bulge_size,
    display_absorbed_examine,
    shrink_grow_size,
    emote_time,
    emote_active,
    contaminates,
    contaminate_flavor,
    contaminate_color,
    egg_type,
    vorespawn_blacklist,
  } = belly;

  return (
    <Flex wrap="wrap">
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Can Taste">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_tastes" })}
              icon={can_taste ? "toggle-on" : "toggle-off"}
              selected={can_taste}
              content={can_taste ? "Yes" : "No"} />
          </LabeledList.Item>
          <LabeledList.Item label="Fleshy Belly">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_wetness" })}
              icon={is_wet ? "toggle-on" : "toggle-off"}
              selected={is_wet}
              content={is_wet ? "Yes" : "No"} />
          </LabeledList.Item>
          <LabeledList.Item label="Internal Loop">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_wetloop" })}
              icon={wet_loop ? "toggle-on" : "toggle-off"}
              selected={wet_loop}
              content={wet_loop ? "Yes" : "No"} />
          </LabeledList.Item>
        </LabeledList>
      </Flex.Item>
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Vore Sound">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_sound" })}
              content={sound} />
            <Button
              onClick={() => act("set_attribute", { attribute: "b_soundtest" })}
              icon="volume-up" />
          </LabeledList.Item>
          <LabeledList.Item label="Release Sound">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_release" })}
              content={release_sound} />
            <Button
              onClick={() => act("set_attribute", { attribute: "b_releasesoundtest" })}
              icon="volume-up" />
          </LabeledList.Item>
          <LabeledList.Item label="Required Examine Size">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_bulge_size" })}
              content={bulge_size * 100 + "%"} />
          </LabeledList.Item>
          <LabeledList.Item label="Display Absorbed Examines">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_display_absorbed_examine" })}
              icon={display_absorbed_examine ? "toggle-on" : "toggle-off"}
              selected={display_absorbed_examine}
              content={display_absorbed_examine ? "True" : "False"} />
          </LabeledList.Item>
          <LabeledList.Item label="Shrink/Grow Size">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_grow_shrink" })}
              content={shrink_grow_size * 100 + "%"} />
          </LabeledList.Item>
          <LabeledList.Item label="Vore Spawn Blacklist">
            <Button
              onClick={() => act("set_attribute", { attribute: "b_vorespawn_blacklist" })}
              icon={vorespawn_blacklist ? "toggle-on" : "toggle-off"}
              selected={vorespawn_blacklist}
              content={vorespawn_blacklist ? "Yes" : "No"} />
          </LabeledList.Item>
        </LabeledList>
      </Flex.Item>
      <Flex.Item basis="100%" mt={1}>
        <Button.Confirm
          fluid
          icon="exclamation-triangle"
          confirmIcon="trash"
          color="red"
          content="Delete Belly"
          confirmContent="This is irreversable!"
          onClick={() => act("set_attribute", { attribute: "b_del" })} />
      </Flex.Item>
    </Flex>
  );
};

const VoreContentsPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    show_pictures,
  } = data;
  const {
    contents,
    belly,
    outside = false,
  } = props;

  return (
    <Fragment>
      {outside && (
        <Button
          textAlign="center"
          fluid
          mb={1}
          onClick={() => act("pick_from_outside", { "pickall": true })}>
          All
        </Button>
      ) || null}
      {show_pictures && (
        <Flex wrap="wrap" justify="center" align="center">
          {contents.map(thing => (
            <Flex.Item key={thing.name} basis="33%">
              <Button
                width="64px"
                color={thing.absorbed ? "purple" : stats[thing.stat]}
                style={{
                  'vertical-align': 'middle',
                  'margin-right': '5px',
                  'border-radius': '20px',
                }}
                onClick={() => act(thing.outside ? "pick_from_outside" : "pick_from_inside", {
                  "pick": thing.ref,
                  "belly": belly,
                })}>
                <img
                  src={"data:image/jpeg;base64, " + thing.icon}
                  width="64px"
                  height="64px"
                  style={{
                    '-ms-interpolation-mode': 'nearest-neighbor',
                    'margin-left': '-5px',
                  }} />
              </Button>
              {thing.name}
            </Flex.Item>
          ))}
        </Flex>
      ) || (
        <LabeledList>
          {contents.map(thing => (
            <LabeledList.Item key={thing.ref} label={thing.name}>
              <Button
                fluid
                mt={-1}
                mb={-1}
                color={thing.absorbed ? "purple" : stats[thing.stat]}
                onClick={() => act(thing.outside ? "pick_from_outside" : "pick_from_inside", {
                  "pick": thing.ref,
                  "belly": belly,
                })}>
                Interact
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )}
    </Fragment>
  );
};

const VoreSelectedBellyInteractions = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    escapable,
    interacts,
    vorespawn_blacklist,
    autotransfer_enabled,
    autotransfer,
  } = belly;

  return (
    <Section title="Belly Interactions" buttons={
      <Button
        onClick={() => act("set_attribute", { attribute: "b_escapable" })}
        icon={escapable ? "toggle-on" : "toggle-off"}
        selected={escapable}
        content={escapable ? "Interactions On" : "Interactions Off"} />
    }>
      {escapable ? (
        <LabeledList>
          <LabeledList.Item label="Escape Chance">
            <Button
              content={interacts.escapechance + "%"}
              onClick={() => act("set_attribute", { attribute: "b_escapechance" })} />
          </LabeledList.Item>
          <LabeledList.Item label="Escape Time">
            <Button
              content={interacts.escapetime / 10 + "s"}
              onClick={() => act("set_attribute", { attribute: "b_escapetime" })} />
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Transfer Chance">
            <Button
              content={interacts.transferchance + "%"}
              onClick={() => act("set_attribute", { attribute: "b_transferchance" })} />
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Location">
            <Button
              content={interacts.transferlocation ? interacts.transferlocation : "Disabled"}
              onClick={() => act("set_attribute", { attribute: "b_transferlocation" })} />
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Absorb Chance">
            <Button
              content={interacts.absorbchance + "%"}
              onClick={() => act("set_attribute", { attribute: "b_absorbchance" })} />
          </LabeledList.Item>
          <LabeledList.Item label="Digest Chance">
            <Button
              content={interacts.digestchance + "%"}
              onClick={() => act("set_attribute", { attribute: "b_digestchance" })} />
          </LabeledList.Item>
        </LabeledList>
      ) : "These options only display while interactions are turned on."}
      <Section title="Auto-Transfer Options" buttons={
        <Button
          onClick={() => act("set_attribute", { attribute: "b_autotransfer_enabled" })}
          icon={autotransfer_enabled ? "toggle-on" : "toggle-off"}
          selected={autotransfer_enabled}
          content={autotransfer_enabled ? "Auto-Transfer Enabled" : "Auto-Transfer Disabled"} />
      }>
        {autotransfer_enabled ? (
          <LabeledList>
            <LabeledList.Item label="Auto-Transfer Chance">
              <Button
                content={autotransfer.autotransferchance + "%"}
                onClick={() => act("set_attribute", { attribute: "b_autotransferchance" })} />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Time">
              <Button
                content={autotransfer.autotransferwait / 10 + "s"}
                onClick={() => act("set_attribute", { attribute: "b_autotransferwait" })} />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Location">
              <Button
                content={autotransfer.autotransferlocation ? autotransfer.autotransferlocation : "Disabled"}
                onClick={() => act("set_attribute", { attribute: "b_autotransferlocation" })} />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Min Amount">
              <Button
                content={autotransfer.autotransfer_min_amount}
                onClick={() => act("set_attribute", { attribute: "b_autotransfer_min_amount" })} />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Max Amount">
              <Button
                content={autotransfer.autotransfer_max_amount}
                onClick={() => act("set_attribute", { attribute: "b_autotransfer_max_amount" })} />
            </LabeledList.Item>
          </LabeledList>
        ) : "These options only display while Auto-Transfer is enabled."}
      </Section>
    </Section>
  );
};

const VoreSelectedBellyStyles = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    belly_fullscreen,
    belly_fullscreen_color,
    mapRef,
    possible_fullscreens,
    disable_hud,
  } = belly;

  return (
    <Fragment>
      <Section title="Belly Fullscreens Preview and Coloring">
        <Flex direction="row">
          <Box backgroundColor={belly_fullscreen_color} width="20px" height="20px" />
          <Button
            icon="eye-dropper"
            onClick={() => act("set_attribute", { attribute: "b_fullscreen_color", val: null })}>
            Select Color
          </Button>
        </Flex>
        <ByondUi
          style={{
            width: '200px',
            height: '200px',
          }}
          params={{
            id: mapRef,
            type: 'map',
          }} />
      </Section>
      <Section height="260px" style={{ overflow: "auto" }}>
        <Section title="Vore FX">
          <LabeledList>
            <LabeledList.Item label="Disable Prey HUD">
              <Button
                onClick={() => act("set_attribute", { attribute: "b_disable_hud" })}
                icon={disable_hud ? "toggle-on" : "toggle-off"}
                selected={disable_hud}
                content={disable_hud ? "Yes" : "No"} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Belly Fullscreens Styles">
          Belly styles:
          <Button
            fluid
            selected={belly_fullscreen === "" || belly_fullscreen === null}
            onClick={() => act("set_attribute", { attribute: "b_fullscreen", val: null })}>
            Disabled
          </Button>
          {Object.keys(possible_fullscreens).map(key => (
            <Button
              key={key}
              width="256px"
              height="256px"
              selected={key === belly_fullscreen}
              onClick={() => act("set_attribute", { attribute: "b_fullscreen", val: key })}>
              <Box
                className={classes([
                  'vore240x240',
                  key,
                ])}
                style={{
                  transform: 'translate(0%, 4%)',
                }} />
            </Button>
          ))}
        </Section>
      </Section>
    </Fragment>
  );
};

const VoreSelectedBellyLiquidOptions = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    show_liq,
    liq_interacts,
    liq_reagent_gen,
    liq_reagent_type,
    liq_reagent_name,
    liq_reagent_transfer_verb,
    liq_reagent_nutri_rate,
    liq_reagent_capacity,
    liq_sloshing,
    liq_reagent_addons,
    show_liq_fullness,
    liq_messages,
    liq_msg1,
    liq_msg2,
    liq_msg3,
    liq_msg4,
    liq_msg5,
  } = belly;

  return (
    <Section title="Liquid Options" buttons={
      <Button
        onClick={() => act("liq_set_attribute", { liq_attribute: "b_show_liq" })}
        icon={show_liq ? "toggle-on" : "toggle-off"}
        selected={show_liq}
        tooltipPosition="left"
        tooltip={"These are the settings for liquid bellies, every belly has a liquid storage."}
        content={show_liq ? "Liquids On" : "Liquids Off"} />
    }>
      {show_liq ? (
        <LabeledList>
          <LabeledList.Item label="Generate Liquids">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_gen" })}
              icon={liq_interacts.liq_reagent_gen? "toggle-on" : "toggle-off"}
              selected={liq_interacts.liq_reagent_gen}
              content={liq_interacts.liq_reagent_gen ? "On" : "Off"} />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Type">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_type" })}
              icon="pen"
              content={liq_interacts.liq_reagent_type} />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Name">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_name" })}
              content={liq_interacts.liq_reagent_name} />
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Verb">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_transfer_verb" })}
              content={liq_interacts.liq_reagent_transfer_verb} />
          </LabeledList.Item>
          <LabeledList.Item label="Generation Time">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_nutri_rate" })}
              icon="clock"
              content={((liq_interacts.liq_reagent_nutri_rate + 1) * 10) / 60 + " Hours"} />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Capacity">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_capacity" })}
              content={liq_interacts.liq_reagent_capacity} />
          </LabeledList.Item>
          <LabeledList.Item label="Slosh Sounds">
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_sloshing" })}
              icon={liq_interacts.liq_sloshing? "toggle-on" : "toggle-off"}
              selected={liq_interacts.liq_sloshing}
              content={liq_interacts.liq_sloshing ? "On" : "Off"} />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Addons">
            {liq_interacts.liq_reagent_addons.length && liq_interacts.liq_reagent_addons.join(", ") || "None"}
            <Button
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_reagent_addons" })}
              ml={1}
              icon="plus" />
          </LabeledList.Item>
          <LabeledList.Item label="Purge Liquids">
            <Button
              color="red"
              onClick={() => act("liq_set_attribute", { liq_attribute: "b_liq_purge" })}
              content={"Purge Liquids"} />
          </LabeledList.Item>
        </LabeledList>
      ) : "These options only display while liquid settings are turned on."}
    </Section>
  );
};

const VoreSelectedBellyLiquidMessages = (props, context) => {
  const { act } = useBackend(context);

  const { belly } = props;
  const {
    liq_interacts,
    liq_reagent_gen,
    liq_reagent_type,
    liq_reagent_name,
    liq_reagent_transfer_verb,
    liq_reagent_nutri_rate,
    liq_reagent_capacity,
    liq_sloshing,
    liq_reagent_addons,
    show_liq_fullness,
    liq_messages,
    liq_msg_toggle1,
    liq_msg_toggle2,
    liq_msg_toggle3,
    liq_msg_toggle4,
    liq_msg_toggle5,
    liq_msg1,
    liq_msg2,
    liq_msg3,
    liq_msg4,
    liq_msg5,
  } = belly;

  return (
    <Section title="Liquid Messages" buttons={
      <Button
        onClick={() => act("liq_set_messages", { liq_messages: "b_show_liq_fullness" })}
        icon={show_liq_fullness ? "toggle-on" : "toggle-off"}
        selected={show_liq_fullness}
        tooltipPosition="left"
        tooltip={"These are the settings for belly visibility when involving liquids fullness."}
        content={show_liq_fullness ? "Messages On" : "Messages Off"} />
    }>
      {show_liq_fullness ? (
        <LabeledList>
          <LabeledList.Item label="0 to 20%">
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg_toggle1" })}
              icon={liq_messages.liq_msg_toggle1? "toggle-on" : "toggle-off"}
              selected={liq_messages.liq_msg_toggle1}
              content={liq_messages.liq_msg_toggle1 ? "On" : "Off"} />
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg1" })}
              content="Examine Message (0 to 20%)" />
          </LabeledList.Item>
          <LabeledList.Item label="20 to 40%">
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg_toggle2" })}
              icon={liq_messages.liq_msg_toggle2? "toggle-on" : "toggle-off"}
              selected={liq_messages.liq_msg_toggle2}
              content={liq_messages.liq_msg_toggle2 ? "On" : "Off"} />
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg2" })}
              content="Examine Message (20 to 40%)" />
          </LabeledList.Item>
          <LabeledList.Item label="40 to 60%">
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg_toggle3" })}
              icon={liq_messages.liq_msg_toggle3? "toggle-on" : "toggle-off"}
              selected={liq_messages.liq_msg_toggle3}
              content={liq_messages.liq_msg_toggle3 ? "On" : "Off"} />
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg3" })}
              content="Examine Message (40 to 60%)" />
          </LabeledList.Item>
          <LabeledList.Item label="60 to 80%">
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg_toggle4" })}
              icon={liq_messages.liq_msg_toggle4? "toggle-on" : "toggle-off"}
              selected={liq_messages.liq_msg_toggle4}
              content={liq_messages.liq_msg_toggle4 ? "On" : "Off"} />
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg4" })}
              content="Examine Message (60 to 80%)" />
          </LabeledList.Item>
          <LabeledList.Item label="80 to 100%">
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg_toggle5" })}
              icon={liq_messages.liq_msg_toggle5? "toggle-on" : "toggle-off"}
              selected={liq_messages.liq_msg_toggle5}
              content={liq_messages.liq_msg_toggle5 ? "On" : "Off"} />
            <Button
              onClick={() => act("liq_set_messages", { liq_messages: "b_liq_msg5" })}
              content="Examine Message (80 to 100%)" />
          </LabeledList.Item>
        </LabeledList>
      ) : "These options only display while liquid examination settings are turned on."}
    </Section>
  );
};

const VoreUserPreferences = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    digestable,
    devourable,
    feeding,
    absorbable,
    allowmobvore,
    vore_sounds,
    digestion_sounds,
    show_vore_fx,
    lickable,
    smellable,
    skull_type,
    digest_leave_remains,
    latejoin_vore,
  } = data.prefs;

  const {
    show_pictures,
  } = data;

  return (
    <Section title="Preferences" buttons={
      <Button icon="eye" selected={show_pictures} onClick={() => act("show_pictures")}>
        Contents Preference: {show_pictures ? "Show Pictures" : "Show List"}
      </Button>
    }>
      <Flex spacing={1} wrap="wrap" justify="center">
        <Flex.Item basis="33%">
          <Button
            onClick={() => act("toggle_devour")}
            icon={devourable ? "toggle-on" : "toggle-off"}
            selected={devourable}
            fluid
            tooltip={"This button is to toggle your ability to be devoured by others. "
            + (devourable ? "Click here to prevent being devoured." : "Click here to allow being devoured.")}
            content={devourable ? "Devouring Allowed" : "No Devouring"} />
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            onClick={() => act("toggle_mobvore")}
            icon={allowmobvore ? "toggle-on" : "toggle-off"}
            selected={allowmobvore}
            fluid
            tooltip={"This button is for those who don't like being eaten by mobs. "
            + (allowmobvore
              ? "Click here to prevent being eaten by mobs."
              : "Click here to allow being eaten by mobs.")}
            tooltipPosition="bottom-right"
            content={allowmobvore ? "Mobs eating you allowed" : "No Mobs eating you"} />
        </Flex.Item>
        <Flex.Item basis="33%" grow={1}>
          <Button
            onClick={() => act("toggle_feed")}
            icon={feeding ? "toggle-on" : "toggle-off"}
            selected={feeding}
            fluid
            tooltip={"This button is to toggle your ability to be fed to or by others vorishly. "
            + (feeding
              ? "Click here to prevent being fed to/by other people."
              : "Click here to allow being fed to/by other people.")}
            content={feeding ? "Feeding Allowed" : "No Feeding"} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            onClick={() => act("toggle_digest")}
            icon={digestable ? "toggle-on" : "toggle-off"}
            selected={digestable}
            fluid
            tooltip={"This button is for those who don't like being digested. It can make you undigestable."
            + (digestable ? " Click here to prevent digestion." : " Click here to allow digestion.")}
            tooltipPosition="bottom-right"
            content={digestable ? "Digestion Allowed" : "No Digestion"} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            onClick={() => act("toggle_absorbable")}
            icon={absorbable ? "toggle-on" : "toggle-off"}
            selected={absorbable}
            fluid
            tooltip={"This button allows preds to know whether you prefer or don't prefer to be absorbed. "
            + (absorbable ? "Click here to disallow being absorbed." : "Click here to allow being absorbed.")}
            content={absorbable ? "Absorption Allowed" : "No Absorption"} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            onClick={() => act("toggle_vore_sounds")}
            icon={vore_sounds ? "volume-up" : "volume-mute"}
            selected={vore_sounds}
            fluid
            tooltip={"Be able to hear vore sounds. "
            + (vore_sounds
              ? "Click here to turn off vore sounds."
              : "Click here to turn on vore sounds.")}
            content={vore_sounds ? "Vore Sounds Enabled" : "Vore Sounds Disabled"} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            onClick={() => act("toggle_digestion_sounds")}
            icon={digestion_sounds ? "volume-up" : "volume-mute"}
            selected={digestion_sounds}
            fluid
            tooltip={"Be able to hear digestion sounds. "
            + (digestion_sounds
              ? "Click here to turn off digestion sounds."
              : "Click here to turn on digestion sounds.")}
            content={digestion_sounds ? "Digestion Sounds Enabled" : "Digestion Sounds Disabled"} />
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            onClick={() => act("toggle_latejoin_vore")}
            icon={latejoin_vore ? "toggle-on" : "toggle-off"}
            selected={latejoin_vore}
            fluid
            tooltip={!latejoin_vore
              ? "Click here to turn off vorish spawnpoint."
              : "Click here to turn on vorish spawnpoint."}
            content={latejoin_vore ? "Vore Spawn Enabled" : "Vore Spawn Disabled"} />
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            onClick={() => act("toggle_leaveremains")}
            icon={digest_leave_remains ? "toggle-on" : "toggle-off"}
            selected={digest_leave_remains}
            fluid
            tooltip={!digest_leave_remains
              ? "Regardless of Predator Setting, you will not leave remains behind."
            + " Click this to allow leaving remains."
              : "Your Predator must have this setting enabled in their belly modes to allow remains to show up,"
            + " if they do not, they will not leave your remains behind, even with this on. Click to disable remains."}
            content={digest_leave_remains ? "Allow Leaving Remains" : "Do Not Allow Leaving Remains"} />
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            onClick={() => act("toggle_vore_fx")}
            icon={show_vore_fx ? "expand" : "toggle-off"}
            selected={show_vore_fx}
            fluid
            tooltip={!show_vore_fx
              ? "Regardless of Predator Setting, you will not see their FX settings."
            + " Click this to enable showing FX."
              : "This setting controls whether or not a pred is allowed to mess with your HUD and fullscreen overlays."
            + " Click to disable all FX."}
            content={show_vore_fx ? "Show Vore FX" : "Do Not Show Vore FX"} />
        </Flex.Item>
        <Flex.Item basis="25%">
          <Button
            onClick={() => act("toggle_lickable")}
            icon={lickable ? "toggle-on" : "toggle-off"}
            selected={lickable}
            fluid
            tooltip={"Be able to be licked by others. "
            + (lickable
              ? "Click here to turn off being able to be licked."
              : "Click here to turn on being able to be licked.")}
            tooltipPosition="bottom-right"
            content={lickable ? "Lickable" : "Unlickable"} />
        </Flex.Item>
        <Flex.Item basis="25%">
          <Button
            fluid
            content="Set Taste"
            icon="grin-tongue"
            onClick={() => act("setflavor")} />
        </Flex.Item>
        <Flex.Item basis="25%">
          <Button
            onClick={() => act("toggle_smellable")}
            icon={smellable ? "toggle-on" : "toggle-off"}
            selected={smellable}
            fluid
            tooltip={"Be able to be smelled by others. "
            + (smellable
              ? "Click here to turn off being able to be smelled."
              : "Click here to turn on being able to be smelled.")}
            content={smellable ? "Smellable" : "Unsmellable"} />
        </Flex.Item>
        <Flex.Item basis="25%">
          <Button
            fluid
            content="Set Smell"
            icon="wind"
            onClick={() => act("setsmell")} />
        </Flex.Item>
      </Flex>
      <Flex>
        <Flex.Item basis="100%">
          <Button
            fluid
            content={"Choose skull, Current: " + (skull_type ? skull_type : "ERROR")}
            icon="skull"
            onClick={() => act("set_skull")} />
        </Flex.Item>
      </Flex>
      <Section>
        <Flex spacing={1}>
          <Flex.Item basis="49%">
            <Button
              fluid
              content="Save Prefs"
              icon="save"
              onClick={() => act("saveprefs")} />
          </Flex.Item>
          <Flex.Item basis="49%" grow={1}>
            <Button
              fluid
              content="Reload Prefs"
              icon="undo"
              onClick={() => act("reloadprefs")} />
          </Flex.Item>
        </Flex>
      </Section>
    </Section>
  );
};
