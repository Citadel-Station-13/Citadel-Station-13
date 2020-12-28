import { round } from 'common/math';
import { useBackend, useLocalState } from '../backend';
import { Box, Section, LabeledList, Button, ProgressBar, Collapsible, Flex, NumberInput, Tabs, Table } from '../components';
import { Fragment } from 'inferno';
import { Window } from '../layouts';
import { FlexItem } from '../components/Flex';

const damageTypes = [
  {
    label: 'Brute',
    type: 'bruteLoss',
  },
  {
    label: 'Burn',
    type: 'fireLoss',
  },
  {
    label: 'Toxin',
    type: 'toxLoss',
  },
  {
    label: 'Oxygen',
    type: 'oxyLoss',
  },
];

export const Sleeper = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    open,
    occupant = {},
    occupied,
  } = data;
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);
  const [tabProps, setTabProps] = useLocalState(context, 'tabProps', {});
  const TAB_RANGE = [
    'Synthesize',
    'Administer',
    'Destroy',
  ];
  const preSortChems = data.chems || [];
  const chems = preSortChems.sort((a, b) => {
    const descA = a.name.toLowerCase();
    const descB = b.name.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  const [hasDesc, setHasDesc] = useLocalState(
    context, 'fs_title', false);
  const synthChems = data.synthchems || [];
  const patientChems = data.occupant.reagents || [];
  return (
    <Window
      width={439}
      height={685}>
      <Window.Content>
        {/* Name of patient*/}
        <Section
          title={occupant.name ? occupant.name : 'No Occupant'}
          minHeight="250px"
          buttons={!!occupant.stat && (
            <Box
              inline
              bold
              color={occupant.statstate}>
              {occupant.stat}
            </Box>
          )}>
          {/* Health*/}
          {!!occupied && (
            <Fragment>
              <ProgressBar
                value={occupant.health}
                minValue={occupant.minHealth}
                maxValue={occupant.maxHealth}
                ranges={{
                  good: [50, Infinity],
                  average: [0, 50],
                  bad: [-Infinity, 0],
                }} />
              <Box mt={1} />
              {/* Damage types*/}
              <LabeledList>
                {damageTypes.map(type => (
                  <LabeledList.Item
                    key={type.type}
                    label={
                      (occupant.is_robotic_organism && type.label === 'Toxin')
                        ? 'Corruption'
                        : type.label
                    }>

                    {type.label === "Brute" && (
                      <ProgressBar
                        value={occupant[type.type]}
                        minValue={0}
                        maxValue={occupant.maxHealth}
                        color="bad" />
                    )}

                    {type.label === "Burn" && (
                      <ProgressBar
                        value={occupant[type.type]}
                        minValue={0}
                        maxValue={occupant.maxHealth}
                        color="orange" />
                    )}

                    {type.label === "Toxin" && (
                      <ProgressBar
                        value={occupant[type.type]}
                        minValue={0}
                        maxValue={occupant.maxHealth}
                        color="olive" />
                    )}

                    {type.label === "Oxygen" && (
                      <ProgressBar
                        value={occupant[type.type]}
                        minValue={0}
                        maxValue={occupant.maxHealth}
                        color="teal" />
                    )}
                  </LabeledList.Item>
                ))}
                <LabeledList.Item
                  label="Metabolic Stress">
                  <ProgressBar
                    minValue={0}
                    maxValue={100}
                    value={data.occupant.metabolicStress}
                    ranges={{
                      violet: [-Infinity, -10],
                      blue: [-10, 0],
                      good: [0, 15],
                      average: [15, 40],
                      bad: [40, Infinity],
                    }}>
                    {data.occupant.metabolicStress}%
                  </ProgressBar>
                </LabeledList.Item>

                <LabeledList.Item label="Blood Volume" pb={1}>
                  <Flex direction="column">
                    <Flex.Item grow={1}>
                      <ProgressBar
                        minValue={0}
                        maxValue={data.occupant.blood.max}
                        value={round(data.occupant.blood.currentBloodVolume)}
                        ranges={{
                          good: [data.occupant.blood.danger, Infinity],
                          average: [(data.occupant.blood.max / 2),
                            data.occupant.blood.danger],
                          bad: [-Infinity, (data.occupant.blood.max / 2)],
                        }}>
                        {round(data.occupant.blood.currentBloodVolume)} cl
                      </ProgressBar>
                    </Flex.Item>
                    <Flex.Item grow={2} textAlign="left">
                      Type: {data.occupant.blood.bloodType}
                    </Flex.Item>
                  </Flex>
                </LabeledList.Item>


                <LabeledList.Item
                  label="Cells"
                  textAlign="center"
                  color={occupant.cloneLoss ? 'bad' : 'good'}>
                  <Flex direction="row">
                    <Flex.Item grow={1}>
                      {occupant.cloneLoss ? 'Damaged' : 'Healthy'}
                    </Flex.Item>
                    <FlexItem grow={2}>
                      <LabeledList>
                        <LabeledList.Item
                          label="Brain"
                          textAlign="center"
                          color={occupant.brainLoss ? 'bad' : 'good'}>
                          {occupant.brainLoss ? 'Abnormal' : 'Healthy'}
                        </LabeledList.Item>
                      </LabeledList>
                    </FlexItem>
                  </Flex>
                </LabeledList.Item>
              </LabeledList>



            </Fragment>
          )}
        </Section>

        <Section
          title="Treatments"
          minHeight="80px"
          buttons={(
            <Button
              icon={open ? 'door-open' : 'door-closed'}
              content={open ? 'Open' : 'Closed'}
              onClick={() => act('door')} />
          )}>
          <Button
            icon={'power-off'}
            mr={2}
            ml={2}
            p={1}
            tooltip={`Performs Dialysis on the patient - Reducing metabolic 
              stress and purging all chems in a patient’s system while slowly
              reducing their blood volume.
              If a liver is unstressed enough, it will begin to heal itself.
              In a pinch, this can stand in for a missing liver.`}
            tooltipPosition="bottom-right"
            disabled={!occupied}
            onClick={() => act('dialysis')}
            selected={data.dialysis}>
            Dialysis
          </Button>
          <Button
            icon={'power-off'}
            p={1}
            mr={2}
            tooltip={`Performs rudimentary radiation purging,
              at the cost of damaging the patient's organs.`}
            tooltipPosition="bottom"
            disabled={!occupied}
            onClick={() => act('antirad')}
            selected={data.antirad}>
            Radiation Purge
          </Button>
          <Button
            icon={'power-off'}
            p={1}
            mr={2}
            tooltip={`Detects chemicals present in a patient's blood stream,
              while slightly reducing each reagent's effectiveness and
              using of some of the patient's nourishment.`}
            tooltipPosition="bottom-left"
            disabled={!occupied}
            onClick={() => act('monitor')}
            selected={data.monitor}>
            Monitor Bloodstream
          </Button>

          {!!data.monitor && (
            patientChems && (
              <Collapsible
                title="Chemicals detected in bloodstream"
                open={1}
                mt={1}
                buttons={(
                  <Button icon="cog"
                    tooltip="Display a short description of each chemical."
                    tooltipPosition="bottom-left"
                    selected={hasDesc}
                    onClick={() => setHasDesc(!hasDesc)} />)}>
                <Table>
                  <Table.Row bold color="blue">
                    <Table.Cell fluid={1}>Name</Table.Cell>
                    <Table.Cell width="20" textAlign="center" fluid={2}>
                      Volume
                    </Table.Cell>
                    {!!hasDesc && (
                      <Table.Cell>
                        Description
                      </Table.Cell>)}
                    <Table.Cell textAlign="center">Overdose</Table.Cell>
                  </Table.Row>
                  {patientChems.map(chem => (
                    <Table.Row direction="row" key="chemKey">
                      <Table.Cell fluid={1}>{chem.name}</Table.Cell>
                      <Table.Cell width="20" textAlign="center">
                        {chem.volume}
                      </Table.Cell>
                      {!!hasDesc && (
                        <Table.Cell>
                          {chem.desc}
                        </Table.Cell>)}
                      {!!chem.OD && (
                        <Table.Cell textAlign="center">
                          {chem.OD}
                        </Table.Cell>)}
                    </Table.Row>
                  ))}
                </Table>
              </Collapsible>
            ))}
        </Section>

        <Section fitted
          title="Medicines"
          buttons={(
            <NumberInput
              unit="u"
              step={data.granularity}
              stepPixelSize={data.granularity}
              value={(data.amount)}
              minValue={0}
              maxValue={100}
              tooltipPosition="bottom-left"
              onDrag={(e, value) => act('amount', {
                amount: value })}
              width="65px" /> 
          )}
          minHeight="165px">
          <Tabs
            fluid={1}
            textAlign="center">
            {TAB_RANGE.map((text, i) => (
              <Tabs.Tab
                key={i}
                selected={i === tabIndex}
                tooltip="test"
                icon={tabProps.icon && 'info-circle'}
                leftSlot={tabProps.leftSlot && (
                  <Button
                    circular
                    compact
                    color="transparent"
                    icon="times" />
                )}
                rightSlot={tabProps.rightSlot && (
                  <Button
                    circular
                    compact
                    color="transparent"
                    icon="times" />
                )}
                onClick={() => setTabIndex(i)}>
                {text}
              </Tabs.Tab>
            ))}
          </Tabs>

          {/* Synth*/}
          {tabIndex === 0 && (
            synthChems.map(chem => (
              <Button
                key={chem.name}
                icon="flask"
                content={chem.name}
                disabled={!chem.synth_allowed}
                width="140px"
                onClick={() => act('synth', {
                  chem: chem.id,
                })} />
            )))}

          {/* Inject*/}
          {tabIndex === 1 && (
            chems.map(chem => (
              <Button
                key={chem.name}
                icon="syringe"
                content={chem.name}
                disabled={!occupied || !chem.allowed}
                width="140px"
                tooltip={"Purity: " + chem.purity}
                color={chem.purityCol}
                onClick={() => act('inject', {
                  chem: chem.id,
                })}> ({chem.vol}u)
              </Button>

            )))}

          {/* Eject*/}
          {tabIndex === 2 && (
            chems.map(chem => (
              <Button
                key={chem.name}
                icon="trash"
                content={chem.name}
                width="140px"
                tooltip={"Purity: " + chem.purity}
                onClick={() => act('purge', {
                  chem: chem.id,
                })}> ({chem.vol}u)
              </Button>
            )))}
        </Section>


        <Section
          title="Storage"
          buttons={(
            <Button
              icon={'flask'}
              content={"Synthesize all available"}
              tooltip={"Synthesizes 50u of all chemicals available to the machine."}
              tooltipPosition="top"
              onClick={() => act('synth_all')} />
          )}>
          <ProgressBar
            minValue={0}
            maxValue={data.tot_capacity}
            value={data.current_vol}>
            {data.current_vol}u
          </ProgressBar>
        </Section>
      </Window.Content>
    </Window>
  );
};
