/* eslint-disable max-len */
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Flex, Collapsible, Icon, LabeledList, NoticeBox, Section, Tabs } from "../components";
import { Window } from "../layouts";

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
  const {
    belly_name,
    is_wet,
    wet_loop,
    mode,
    verb,
    desc,
    sound,
    release_sound,
    can_taste,
    bulge_size,
    escapable,
    interacts,
    contents,
  } = belly;

  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

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
      </Tabs>
      {tabIndex === 0 && (
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
              color="red"
              onClick={() => act("set_attribute", { attribute: "b_msgs", msgtype: "reset" })}
              content="Reset Messages" />
          </LabeledList.Item>
        </LabeledList>
      ) || tabIndex === 1 && (
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
      ) || tabIndex === 2 && (
        <VoreContentsPanel outside contents={contents} />
      ) || tabIndex === 3 && (
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
        </Section>
      ) || "Error"}
    </Fragment>
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
    lickable,
    smellable,
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
            tooltipPosition="bottom-start"
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
            tooltipPosition="bottom-start"
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
            tooltipPosition="bottom-start"
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
