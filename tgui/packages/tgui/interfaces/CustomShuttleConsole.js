/* eslint-disable react/jsx-closing-tag-location */
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, Modal, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

export const CustomShuttleConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    docked_location,
    ship_name = "ERROR",
    shuttle_mass = 0,
    engine_force = 0,
    engines = 0,
    calculated_speed = 0,
    calculated_non_operational_thrusters = 0,
    calculated_consumption = 0,
    calculated_cooldown = 0,
    locations = [],
    destination = null,
  } = data;
  return (
    <Window
      width={385}
      height={475}>
      <Window.Content overflow="auto">
        <Section fluid fill grow={1}>
          {!docked_location ? (
            <Modal
              ml={1}
              mt={1}
              width={26}
              height={12}
              fontSize="28px"
              fontFamily="monospace"
              textAlign="center">
              <Flex>
                <Flex.Item mt={8} ml={3}>
                  <Icon
                    name="minus-circle" />
                </Flex.Item>
                <Flex.Item
                  mt={5}
                  ml={2}
                  color="yellow">
                  {"Shuttle Link Required."}
                </Flex.Item>
              </Flex>
            </Modal>
          ) : (
            <>
              <font size="+3"><center>{ship_name}</center></font>
              <Section title="Info">
                <LabeledList>
                  <LabeledList.Item label="Current Location">
                    {docked_location}
                  </LabeledList.Item>
                  <LabeledList.Item label="Shuttle Mass">
                    {shuttle_mass / 10}ton{shuttle_mass !== 1 ? "s" : null}
                  </LabeledList.Item>
                  <LabeledList.Item label="Engine Force">
                    {engine_force}Kn ({engines} engine{engines !== 1 ? "s" : null})
                  </LabeledList.Item>
                  <LabeledList.Item label="Sublight speed">
                    {calculated_speed}ms{<sup>-1</sup>} {calculated_speed < 1 ? <Tooltip content="INSUFFICIENT ENGINE POWER"><Icon name="exclamation-triangle" color="yellow" /></Tooltip> : null}
                  </LabeledList.Item>
                  {calculated_non_operational_thrusters.len
                    ? <LabeledList.Item label="Warning">
                      {calculated_non_operational_thrusters} thruster{calculated_non_operational_thrusters !== 1 ? "s are" : " is"} not operational.
                    </LabeledList.Item>
                    : null}
                  <LabeledList.Item label="Fuel Consumption">
                    {calculated_consumption} unit{calculated_consumption !== 1 ? "s" : null} per travel
                  </LabeledList.Item>
                  <LabeledList.Item label="Engine Cooldown">
                    {calculated_cooldown}s
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <Section title="Destinations">
                {locations.length===0 && (
                  <Box
                    mb={1.7}
                    color="bad">
                    No valid destinations
                  </Box>
                ) || (
                  <Table>
                    {locations.map(location => (
                      <tr class="Table__row candystripe" key={location.id}>
                        {location.name} <td>({location.dist}m)</td>
                        <td>
                          <Button
                            icon="crosshairs"
                            selected={location.id === destination}
                            onClick={() => act("setloc", {
                              setloc: location.id,
                            })} />
                        </td>
                      </tr>
                    ))}
                  </Table>
                )}
              </Section>
              <Section>
                <Button
                  content="Initiate Flight"
                  icon="rocket"
                  disabled={calculated_speed < 1 || !destination}
                  onClick={() => act('fly')}
                  fluid />
              </Section>
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const getLocationNameById = (locations, id) => {
  return locations?.find(location => location.id === id)?.name;
};

const getLocationIdByName = (locations, name) => {
  return locations?.find(location => location.name === name)?.id;
};

const STATUS_COLOR_KEYS = {
  "In Transit": "good",
  "Idle": "average",
  "Igniting": "average",
  "Recharging": "average",
  "Missing": "bad",
  "Unauthorized Access": "bad",
  "Locked": "bad",
};
