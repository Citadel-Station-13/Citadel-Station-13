import { useBackend } from '../backend';
import { Box, Section, LabeledList, Button, ProgressBar } from '../components';
import { Window } from '../layouts';
import { Fragment } from 'inferno';

export const Mrs = (props, context) => {
	const { act, data } = useBackend(context);
	const {
		open,
		occupant = {},
		occupied,
	} = data;
	const organs = data.occupant.organs || [];
	const Btrauma = data.occupant.traumalist || [];
	const missingOrgans = data.occupant.missing_organs || [];

	<Window
		width={480}
		height={820}>
		<Window.Content>
			<Section
				title={occupant.name ? occupant.name : 'No Occupant'}
				minHeight="210px"
				buttons={!!occupant.stat && (
					<Box
						inline
						bold
						color={occupant.statstate}>
						{occupant.stat}
					</Box>
				)}>
				{!!occupied && (
					<ProgressBar
						value={occupant.health}
						minValue={occupant.minHealth}
						maxValue={occupant.maxHealth}
						ranges={{
							good: [50, Infinity],
							average: [0, 50],
							bad: [-Infinity, 0],
						}} />
				)}
			</Section>


			<Section
				title={"Controls"}>
				<Button
					icon={open ? 'door-open' : 'door-closed'}
					content={open ? 'Open' : 'Closed'}
					onClick={() => act('door')} />
				<Button
					icon={data.scanning ? 'power-off' : 'close'}
					disabled={!!data.occupant}
					selected={data.scanning}
					onClick={() => act('scan')} />
				{!!data.scanning && (
					<ProgressBar
						title={"Scanning..."}
						minValue={0}
						maxValue={data.scantime}
						value={data.scancount} />
				)}
			</Section>


			{!!occupied && (
				<Section
					title={'Organ Status'}
					minHeight="420px">

					{/* Process each organ in an incredbily janky way */}
					<LabeledList>
						{organs.map(organ => (
							<LabeledList.Item
								key={organ.name}
								label={organ.name}>
								{organ.name}

								<ProgressBar
									title={organ.health}
									value={organ.health}
									minValue={0}
									maxValue={organ.max_damage}
									ranges={{
										good: [50, Infinity],
										average: [0, 50],
										bad: [-Infinity, 0],
									}} />

								{!!organ.slot === "BRAIN" && (
									Btrauma.map(trauma => (
										<LabeledList.Item
											key={trauma.Bname}
											label={trauma.resist + trauma.Bname}
											color={trauma.colourB}>
											{trauma.resist} {trauma.Bname}
										</LabeledList.Item>
									))
								)}

								{!!organ.slot === "LIVER" && (
									<Section
										title={"Stress"}>
										<ProgressBar
											minValue={data.occupant.metabolicStressMin}
											maxValue={data.occupant.metabolicStressMax}
											value={data.occupant.metabolicStressVar}
											color={data.occupant.metabolicColour}
											title={data.occupant.metabolicStress} />
									</Section>
								)}

								{!!organ.slot === "STOMACH" && (
									!!data.occupant.pH && (
										<Section
											title={"pH"}>
											<ProgressBar
												minValue={0}
												maxValue={14}
												value={data.occupant.pH}
												color={data.occupant.pHcolor}
												title={data.occupant.pHState} />
											<Section
												title={"Volume"}>
												<Box
													color={data.occupant.stomachColor}>
													{data.occupant.stomachVol}u
											</Box>
											</Section>
										</Section>

									)

								)}

								{!!organ.slot === "LUNGS" && (
									!!data.occupant.lungcollapse && (
										<Box
											color={'average'}>
											{data.occupant.lungcollapse}
										</Box>
									)
								)}
							</LabeledList.Item>
						))}
						{missingOrgans.map(mOrgan => (
							<LabeledList.Item
								key={mOrgan.name}
								label={mOrgan.name}>
								{mOrgan.name}
								<Box
									color={'bad'}>
									{'MISSING'}
								</Box>
							</LabeledList.Item>))}
					</LabeledList>
				</Section>
			)}
		</Window.Content>
	</Window>;
};