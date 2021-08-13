import { useBackend } from "../../backend";
import { NumberInput, Button, LabeledList, Section, ProgressBar } from "../../components";

enum ControlFlags {
  ControlActive = 1,
  ControlPressure = 2,
  ControlPower = 4,
  ControlRate = 8,
  ViewPowerUsage = 16,
  ViewFlowRate = 32
}

type AtmosPowerControlProps = {
  data?: AtmosPowerControlData;
  target?: String
}

type AtmosPowerControlData = {
  power_max: Number;
  pressure_max: Number;
  pressure_sane_max: Number;
  control_flags: Number;
  rate_max: Number;
  power_setting: Number;
  pressure_setting: Number;
  rate_setting: Number;
  on: Number;
  power_current: Number;
  rate_current: Number
}

export const AtmosPowerControl = (props, context) => {
  const { act, data } = useBackend<AtmosPowerControlData>(context);
  let using: AtmosPowerControlData = props.data || data;

  return (
    <Section>
      <LabeledList>
        {using.control_flags.valueOf() & ControlFlags.ControlActive && (
          <LabeledList.Item label="Power">
            <Button
              icon={using.on? 'power-off' : 'times'}
              content={using.on ? 'On' : 'Off'}
              selected={using.on}
              onClick={() => act('toggle')} />
          </LabeledList.Item>
        )}
        {using.control_flags.valueOf() & ControlFlags.ControlPower && (
          <LabeledList.Item label="Power Rating">
            <NumberInput
              animated
              value={using.power_setting.valueOf()}
              width="63px"
              unit="W"
              minValue={0}
              maxValue={using.power_max}
              onChange={(e, value) => act('power', {
                power: value,
              })} />
            <Button
              ml={1}
              icon="plus"
              content="Max"
              disabled={data.power_setting === data.power_max}
              onClick={() => act('power', {
                power: 'max',
              })} />
          </LabeledList.Item>
        )}
        {using.control_flags.valueOf() & ControlFlags.ControlPressure && (
          <LabeledList.Item label="Pressure Regulator">
            <NumberInput
              animated
              value={using.pressure_setting.valueOf()}
              width="63px"
              unit="W"
              minValue={0}
              maxValue={using.pressure_max}
              onChange={(e, value) => act('pressure', {
                pressure: value,
              })} />
            <Button
              ml={1}
              icon="plus"
              content="Max"
              disabled={data.pressure_setting === data.pressure_sane_max}
              onClick={() => act('pressure', {
                pressure: 'max',
              })} />
            <Button
              ml={1}
              icon="exclamation"
              content="OC"
              disabled={data.pressure_setting === data.pressure_max}
              onClick={() => act('pressure', {
                pressure: 'super',
              })} />
          </LabeledList.Item>
        )}
        {using.control_flags.valueOf() & ControlFlags.ControlRate && (
          <LabeledList.Item label="Pump Rate">
            <NumberInput
              animated
              value={using.rate_setting.valueOf()}
              width="63px"
              unit="L/s"
              minValue={0}
              maxValue={using.rate_max}
              onChange={(e, value) => act('rate', {
                rate: value,
              })} />
            <Button
              ml={1}
              icon="plus"
              content="Max"
              disabled={data.rate_setting === data.rate_max}
              onClick={() => act('rate', {
                rate: 'max',
              })} />
          </LabeledList.Item>
        )}
        {using.control_flags.valueOf() & ControlFlags.ViewFlowRate && (
          <LabeledList.Item label="Flow Rate">
            <ProgressBar
              value={using.rate_current}
              maxValue={using.rate_max}
              minValue={0}
              ranges={{
                good: [0.7, Infinity],
                average: [0.3, 0.7],
                bad: [-Infinity, 0.3],
              }} />
          </LabeledList.Item>
        )}
        {using.control_flags.valueOf() & ControlFlags.ViewPowerUsage && (
          <LabeledList.Item label="Flow Rate">
            <ProgressBar
              value={using.power_current}
              maxValue={using.power_max}
              minValue={0}
              ranges={{
                good: [-Infinity, 0.3],
                average: [0.3, 0.7],
                bad: [0.7, Infinity],
              }} />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
