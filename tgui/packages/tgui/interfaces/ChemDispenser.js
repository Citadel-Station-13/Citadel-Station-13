import { toFixed } from 'common/math';
import { toTitleCase } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { AnimatedNumber, Box, Button, Icon, LabeledList, ProgressBar, Section, Table, NumberInput } from '../components';
import { Window } from '../layouts';

export const ChemDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const recording = !!data.recordingRecipe;
  const [hasCol, setHasCol] = useLocalState(
    context, 'fs_title', false);
  const [modeToggle, setModeToggle] = useLocalState(
    context, 'mode_toggle', true);
  const {
    storedContents = [],
  } = data;
  // TODO: Change how this piece of shit is built on server side
  // It has to be a list, not a fucking OBJECT!
  const recipes = Object.keys(data.recipes)
    .map(name => ({
      name,
      contents: data.recipes[name],
    }));
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = recording
    && Object.keys(data.recordingRecipe)
      .map(id => ({
        id,
        name: toTitleCase(id.replace(/_/, ' ')),
        volume: data.recordingRecipe[id],
      }))
    || data.beakerContents
    || [];
  return (
    <Window
      width={565}
      height={data.canStore ? 720 : 620}
      resizable>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            [(recording && (
              <Box inline mx={1} color="red">
                <Icon name="circle" mr={1} />
                Recording
              </Box>
            )),
            <Button     // eslint-disable-line
              key="colorButton"
              icon="cog"
              disabled={!data.isBeakerLoaded}
              tooltip="Alternate between buttons and radial input"
              tooltipPosition="bottom-end"
              selected={modeToggle}
              onClick={() => setModeToggle(!modeToggle)} />]
          }>
          <LabeledList>
            <LabeledList.Item label="Energy">
              <ProgressBar
                value={data.energy / data.maxEnergy}>
                {toFixed(data.energy) + ' units'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Recipes"
          buttons={(
            <Fragment>
              {!recording && (
                <Box inline mx={1}>
                  <Button
                    color="transparent"
                    content="Clear recipes"
                    onClick={() => act('clear_recipes')} />
                </Box>
              )}
              {!recording && (
                <Button
                  icon="circle"
                  disabled={!data.isBeakerLoaded}
                  content="Record"
                  onClick={() => act('record_recipe')} />
              )}
              {recording && (
                <Button
                  icon="ban"
                  color="transparent"
                  content="Discard"
                  onClick={() => act('cancel_recording')} />
              )}
              {recording && (
                <Button
                  icon="save"
                  color="green"
                  content="Save"
                  onClick={() => act('save_recording')} />
              )}
            </Fragment>
          )}>
          <Box mr={-1}>
            {recipes.map(recipe => (
              <Button
                key={recipe.name}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                content={recipe.name}
                onClick={() => act('dispense_recipe', {
                  recipe: recipe.name,
                })} />
            ))}
            {recipes.length === 0 && (
              <Box color="light-gray">
                No recipes.
              </Box>
            )}
          </Box>
        </Section>
        <Section
          key="dispense"
          title="Dispense"
          buttons={(
            [modeToggle ? (
              beakerTransferAmounts.map(amount => (
                <Button
                  key={amount}
                  icon="plus"
                  selected={amount === data.amount}
                  content={amount}
                  onClick={() => act('amount', {
                    target: amount,
                  })} />
              ))) : (!!data.isBeakerLoaded
                && <NumberInput
                  key="dispenseInput"
                  width="65px"
                  unit="u"
                  step={data.stepAmount}
                  stepPixelSize={data.stepAmount}
                  disabled={!data.isBeakerLoaded}
                  value={data.amount}
                  minValue={1}
                  maxValue={data.beakerMaxVolume}
                  onDrag={(e, amount) => act('amount', {
                    target: amount,
                  })} />),
            <Button       // eslint-disable-line
              key="colorButton"
              icon="cog"
              tooltip={"Color code the reagents by pH"}
              tooltipPosition={"bottom-end"}
              selected={hasCol}
              onClick={() => setHasCol(!hasCol)} />]
          )}>
          <Box mr={-1}>
            {data.chemicals.map(chemical => (
              <Button
                key={chemical.id}
                icon="tint"
                width="129.5px"
                lineHeight={1.75}
                content={chemical.title}
                tooltip={"pH: " + chemical.pH}
                backgroundColor={hasCol ? chemical.pHCol : "primary"}
                onClick={() => act('dispense', {
                  reagent: chemical.id,
                })} />
            ))}
          </Box>
        </Section>
        {!!data.canStore && (
          <Section
            title="Storage"
            buttons={
              <Box>
                Transfer amount:
                <AnimatedNumber
                  initial={5}
                  value={data.amount} />
                u
              </Box>
            }>
            <ProgressBar
              value={data.storedVol / data.maxVol}>
              {toFixed(data.storedVol) + ' units / ' + data.maxVol + ' units'}
            </ProgressBar>
            <ChemicalBuffer>
              {storedContents.map(chemical => (
                <ChemicalBufferEntry
                  key={chemical.id}
                  chemical={chemical}
                  transferTo="beaker" />
              ))}
            </ChemicalBuffer>
          </Section>
        )}
        <Section
          title="Beaker"
          buttons={(
            beakerTransferAmounts.map(amount => (
              <Button
                key={amount}
                icon="minus"
                disabled={recording}
                content={amount}
                onClick={() => act('remove', { amount })} />
            ))
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Beaker"
              buttons={!!data.isBeakerLoaded && (
                <Button
                  icon="eject"
                  content="Eject"
                  disabled={!data.isBeakerLoaded}
                  onClick={() => act('eject')} />
              )}>
              {recording
                && 'Virtual beaker'
                || data.isBeakerLoaded
                && (
                  <Fragment>
                    <AnimatedNumber
                      initial={0}
                      value={data.beakerCurrentVolume} />
                    /{data.beakerMaxVolume} units
                  </Fragment>
                )
                || 'No beaker'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Contents">
              <Box color="label">
                {(!data.isBeakerLoaded && !recording) && 'N/A'
                  || beakerContents.length === 0 && 'Nothing'}
              </Box>
              <ChemicalBeaker>
                {beakerContents.map(chemical => (
                  <ChemicalBeakerEntry
                    key={chemical.id}
                    chemical={chemical}
                    transferTo="beaker" />
                ))}
              </ChemicalBeaker>
              <Box
                key={"pH"}>
                pH:
                <AnimatedNumber
                  initial={7.0}
                  value={data.beakerCurrentpH} />
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};


const ChemicalBuffer = Table;

const ChemicalBufferEntry = (props, context) => {
  const { act, data } = useBackend(context);
  const { chemical, transferTo } = props;
  return (
    <Table.Row key={chemical.id}>
      <Table.Cell color="label">
        <AnimatedNumber
          value={chemical.volume}
          initial={0} />
        {` units of ${chemical.name}`}
      </Table.Cell>
      <Table.Cell collapsing>
        <Button
          content="Dispense"
          icon="download"
          disabled={!!data.recordingRecipe || !data.isBeakerLoaded}
          mt={0.5}
          onClick={() => act('unstore', {
            id: chemical.id,
          })} />
      </Table.Cell>
    </Table.Row>
  );
};

const ChemicalBeaker = Table;

const ChemicalBeakerEntry = (props, context) => {
  const { act, data } = useBackend(context);
  const { chemical, transferTo } = props;
  return (
    <Table.Row key={chemical.id}>
      <Table.Cell color="label">
        <AnimatedNumber
          value={chemical.volume}
          initial={0} />
        {` units of ${chemical.name}`}
      </Table.Cell>
      {!!data.canStore && (
        <Table.Cell collapsing>
          <Button
            content="Store"
            icon="upload"
            disabled={!!data.recordingRecipe}
            mt={0.5}
            onClick={() => act('store', {
              id: chemical.id,
            })} />
        </Table.Cell>
      )}
    </Table.Row>
  );
};
