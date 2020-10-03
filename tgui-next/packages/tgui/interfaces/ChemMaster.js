import { Component, Fragment } from 'inferno';
import { act } from '../byond';
import { AnimatedNumber, Box, Button, ColorBox, LabeledList, NumberInput, Section, Table } from '../components';

export const ChemMaster = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  const {
    screen,
    beakerContents = [],
    bufferContents = [],
    beakerCurrentVolume,
    beakerMaxVolume,
    isBeakerLoaded,
    isPillBottleLoaded,
    pillBottleCurrentAmount,
    pillBottleMaxAmount,
  } = data;

  return (
    <Fragment>
      <Section
        title="Beaker"
        buttons={!!data.isBeakerLoaded && (
          <Fragment>
            <Box inline color="label" mr={2}>
              <AnimatedNumber
                value={beakerCurrentVolume}
                initial={0} />
              {` / ${beakerMaxVolume} units`}
            </Box>
            <Button
              icon="eject"
              content="Eject"
              onClick={() => act(ref, 'eject')} />
          </Fragment>
        )}>
        {!isBeakerLoaded && (
          <Box color="label" mt="3px" mb="5px">
            No beaker loaded.
          </Box>
        )}
        {!!isBeakerLoaded && beakerContents.length === 0 && (
          <Box color="label" mt="3px" mb="5px">
            Beaker is empty.
          </Box>
        )}
        <ChemicalBuffer>
          {beakerContents.map(chemical => (
            <ChemicalBufferEntry
              key={chemical.id}
              state={state}
              chemical={chemical}
              transferTo="buffer" />
          ))}
        </ChemicalBuffer>
      </Section>
      <Section
        title="Buffer"
        buttons={(
          <Fragment>
            <Box inline color="label" mr={1}>
              Mode:
            </Box>
            <Button
              color={data.mode ? 'good' : 'bad'}
              icon={data.mode ? 'exchange-alt' : 'times'}
              content={data.mode ? 'Transfer' : 'Destroy'}
              onClick={() => act(ref, 'toggleMode')} />
          </Fragment>
        )}>
        {bufferContents.length === 0 && (
          <Box color="label" mt="3px" mb="5px">
            Buffer is empty.
          </Box>
        )}
        <ChemicalBuffer>
          {bufferContents.map(chemical => (
            <ChemicalBufferEntry
              key={chemical.id}
              state={state}
              chemical={chemical}
              transferTo="beaker" />
          ))}
        </ChemicalBuffer>
      </Section>
      <Section
        title="Packaging">
        <PackagingControls state={state} />
      </Section>
      {!!isPillBottleLoaded && (
        <Section
          title="Pill Bottle"
          buttons={(
            <Fragment>
              <Box inline color="label" mr={2}>
                {pillBottleCurrentAmount} / {pillBottleMaxAmount} pills
              </Box>
              <Button
                icon="eject"
                content="Eject"
                onClick={() => act(ref, 'ejectPillBottle')} />
            </Fragment>
          )} />
      )}
    </Fragment>
  );
};

const ChemicalBuffer = Table;

const ChemicalBufferEntry = props => {
  const { state, chemical, transferTo } = props;
  const { ref } = state.config;
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
          content="1"
          onClick={() => act(ref, 'transfer', {
            id: chemical.id,
            amount: 1,
            to: transferTo,
          })} />
        <Button
          content="5"
          onClick={() => act(ref, 'transfer', {
            id: chemical.id,
            amount: 5,
            to: transferTo,
          })} />
        <Button
          content="10"
          onClick={() => act(ref, 'transfer', {
            id: chemical.id,
            amount: 10,
            to: transferTo,
          })} />
        <Button
          content="All"
          onClick={() => act(ref, 'transfer', {
            id: chemical.id,
            amount: 1000,
            to: transferTo,
          })} />
        <Button
          icon="ellipsis-h"
          title="Custom amount"
          onClick={() => act(ref, 'transfer', {
            id: chemical.id,
            amount: -1,
            to: transferTo,
          })} />
        <Button
          icon="question"
          title="Analyze"
          onClick={() => act(ref, 'analyze', {
            id: chemical.id,
          })} />
      </Table.Cell>
    </Table.Row>
  );
};

const PackagingControlsItem = props => {
  const {
    label,
    amountUnit,
    amount,
    onChangeAmount,
    onCreate,
    sideNote,
  } = props;
  return (
    <LabeledList.Item label={label}>
      <NumberInput
        width={14}
        unit={amountUnit}
        step={1}
        stepPixelSize={15}
        value={amount}
        minValue={1}
        maxValue={10}
        onChange={onChangeAmount} />
      <Button ml={1}
        content="Create"
        onClick={onCreate} />
      <Box inline ml={1}
        color="label"
        content={sideNote} />
    </LabeledList.Item>
  );
};

class PackagingControls extends Component {
  constructor() {
    super();
    this.state = {
      pillAmount: 1,
      patchAmount: 1,
      bottleAmount: 1,
      packAmount: 1,
      vialAmount: 1,
      dartAmount: 1,
    };
  }

  render() {
    const { state, props } = this;
    const { ref } = props.state.config;
    const {
      pillAmount,
      patchAmount,
      bottleAmount,
      packAmount,
      vialAmount,
      dartAmount,
    } = this.state;
    const {
      condi,
      chosenPillStyle,
      pillStyles = [],
    } = props.state.data;
    return (
      <LabeledList>
        {!condi && (
          <LabeledList.Item label="Pill type">
            {pillStyles.map(pill => (
              <Button
                key={pill.id}
                width={5}
                selected={pill.id === chosenPillStyle}
                textAlign="center"
                color="transparent"
                onClick={() => act(ref, 'pillStyle', { id: pill.id })}>
                <Box mx={-1} className={pill.className} />
              </Button>
            ))}
          </LabeledList.Item>
        )}
        {!condi && (
          <PackagingControlsItem
            label="Pills"
            amount={pillAmount}
            amountUnit="pills"
            sideNote="max 50u"
            onChangeAmount={(e, value) => this.setState({
              pillAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'pill',
              amount: pillAmount,
              volume: 'auto',
            })} />
        )}
        {!condi && (
          <PackagingControlsItem
            label="Patches"
            amount={patchAmount}
            amountUnit="patches"
            sideNote="max 40u"
            onChangeAmount={(e, value) => this.setState({
              patchAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'patch',
              amount: patchAmount,
              volume: 'auto',
            })} />
        )}
        {!condi && (
          <PackagingControlsItem
            label="Bottles"
            amount={bottleAmount}
            amountUnit="bottles"
            sideNote="max 30u"
            onChangeAmount={(e, value) => this.setState({
              bottleAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'bottle',
              amount: bottleAmount,
              volume: 'auto',
            })} />
        )}
        {!condi && (
          <PackagingControlsItem
            label="Hypovials"
            amount={vialAmount}
            amountUnit="vials"
            sideNote="max 60u"
            onChangeAmount={(e, value) => this.setState({
              vialAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'hypoVial',
              amount: vialAmount,
              volume: 'auto',
            })} />
        )}
        {!condi && (
          <PackagingControlsItem
            label="Smartdarts"
            amount={dartAmount}
            amountUnit="darts"
            sideNote="max 20u"
            onChangeAmount={(e, value) => this.setState({
              dartAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'smartDart',
              amount: dartAmount,
              volume: 'auto',
            })} />
        )}
        {!!condi && (
          <PackagingControlsItem
            label="Packs"
            amount={packAmount}
            amountUnit="packs"
            sideNote="max 10u"
            onChangeAmount={(e, value) => this.setState({
              packAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'condimentPack',
              amount: packAmount,
              volume: 'auto',
            })} />
        )}
        {!!condi && (
          <PackagingControlsItem
            label="Bottles"
            amount={bottleAmount}
            amountUnit="bottles"
            sideNote="max 50u"
            onChangeAmount={(e, value) => this.setState({
              bottleAmount: value,
            })}
            onCreate={() => act(ref, 'create', {
              type: 'condimentBottle',
              amount: bottleAmount,
              volume: 'auto',
            })} />
        )}
      </LabeledList>
    );
  }
}

const AnalysisResults = props => {
  const { state, fermianalyze } = props;
  const { ref } = state.config;
  const { analyzeVars } = state.data;
  return (
    <Section
      title="Analysis Results"
      buttons={(
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => act(ref, 'goScreen', {
            screen: 'home',
          })} />
      )}>
      {!fermianalyze && (
        <LabeledList>
          <LabeledList.Item label="Name">
            {analyzeVars.name}
          </LabeledList.Item>
          <LabeledList.Item label="State">
            {analyzeVars.state}
          </LabeledList.Item>
          <LabeledList.Item label="Color">
            <ColorBox color={analyzeVars.color} mr={1} />
            {analyzeVars.color}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {analyzeVars.description}
          </LabeledList.Item>
          <LabeledList.Item label="Metabolization Rate">
            {analyzeVars.metaRate} u/minute
          </LabeledList.Item>
          <LabeledList.Item label="Overdose Threshold">
            {analyzeVars.overD}
          </LabeledList.Item>
          <LabeledList.Item label="Addiction Threshold">
            {analyzeVars.addicD}
          </LabeledList.Item>
        </LabeledList>
      )}
      {!!fermianalyze && (
        <LabeledList>
          <LabeledList.Item label="Name">
            {analyzeVars.name}
          </LabeledList.Item>
          <LabeledList.Item label="State">
            {analyzeVars.state}
          </LabeledList.Item>
          <LabeledList.Item label="Color">
            <ColorBox color={analyzeVars.color} mr={1} />
            {analyzeVars.color}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {analyzeVars.description}
          </LabeledList.Item>
          <LabeledList.Item label="Metabolization Rate">
            {analyzeVars.metaRate} u/minute
          </LabeledList.Item>
          <LabeledList.Item label="Overdose Threshold">
            {analyzeVars.overD}
          </LabeledList.Item>
          <LabeledList.Item label="Addiction Threshold">
            {analyzeVars.addicD}
          </LabeledList.Item>
          <LabeledList.Item label="Purity">
            {analyzeVars.purityF}
          </LabeledList.Item>
          <LabeledList.Item label="Inverse Ratio">
            {analyzeVars.inverseRatioF}
          </LabeledList.Item>
          <LabeledList.Item label="Purity E">
            {analyzeVars.purityE}
          </LabeledList.Item>
          <LabeledList.Item label="Lower Optimal Temperature">
            {analyzeVars.minTemp}
          </LabeledList.Item>
          <LabeledList.Item label="Upper Optimal Temperature">
            {analyzeVars.maxTemp}
          </LabeledList.Item>
          <LabeledList.Item label="Explosive Temperature">
            {analyzeVars.eTemp}
          </LabeledList.Item>
          <LabeledList.Item label="pH Peak">
            {analyzeVars.pHpeak}
          </LabeledList.Item>
        </LabeledList>
      )}
    </Section>
  );
};
