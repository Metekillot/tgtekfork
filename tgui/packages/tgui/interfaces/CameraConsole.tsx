import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { BooleanLike, classes } from 'common/react';
import { createSearch } from 'common/string';
import { useBackend, useLocalState } from '../backend';
<<<<<<< HEAD
import {
  Button,
  ByondUi,
  Input,
  NoticeBox,
  Section,
  Stack,
} from '../components';
import { Window } from '../layouts';

type Data = {
  activeCamera: Camera & { status: BooleanLike };
  cameras: Camera[];
  can_spy: BooleanLike;
  mapRef: string;
=======
import { Button, ByondUi, Input, NoticeBox, Section, Stack } from '../components';
import { Window } from '../layouts';

type Data = {
  activeCamera: Camera & { status: BooleanLike };
  cameras: Camera[];
  can_spy: BooleanLike;
  mapRef: string;
<<<<<<< HEAD
  cameras: Camera[];
  activeCamera: Camera & { status: BooleanLike };
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
=======
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
  network: string[];
};

type Camera = {
  name: string;
<<<<<<< HEAD
  ref: string;
=======
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
};

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
const prevNextCamera = (
  cameras: Camera[],
<<<<<<< HEAD
  activeCamera: Camera & { status: BooleanLike },
) => {
  if (!activeCamera || cameras.length < 2) {
    return [];
  }

  const index = cameras.findIndex((camera) => camera.ref === activeCamera.ref);

  switch (index) {
    case -1: // Current camera is not in the list
      return [cameras[cameras.length - 1].ref, cameras[0].ref];

    case 0: // First camera
      if (cameras.length === 2) return [cameras[1].ref, cameras[1].ref]; // Only two

      return [cameras[cameras.length - 1].ref, cameras[index + 1].ref];

    case cameras.length - 1: // Last camera
      if (cameras.length === 2) return [cameras[0].ref, cameras[0].ref];

      return [cameras[index - 1].ref, cameras[0].ref];

    default:
      // Middle camera
      return [cameras[index - 1].ref, cameras[index + 1].ref];
  }
=======
  activeCamera: Camera & { status: BooleanLike }
) => {
  if (!activeCamera || cameras.length < 2) {
    return [];
  }
<<<<<<< HEAD
<<<<<<< HEAD
  const index = cameras.findIndex(
    (camera) => camera?.name === activeCamera.name
  );
  return [cameras[index - 1]?.name, cameras[index + 1]?.name];
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
=======
=======

>>>>>>> d3747254e60 (Fixes camera console bluescreen (#78926))
  const index = cameras.findIndex((camera) => camera.ref === activeCamera.ref);

  switch (index) {
    case -1: // Current camera is not in the list
      return [cameras[cameras.length - 1].ref, cameras[0].ref];

    case 0: // First camera
      if (cameras.length === 2) return [cameras[1].ref, cameras[1].ref]; // Only two

<<<<<<< HEAD
  return [cameras[index - 1].ref, cameras[index + 1].ref];
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
=======
      return [cameras[cameras.length - 1].ref, cameras[index + 1].ref];

    case cameras.length - 1: // Last camera
      if (cameras.length === 2) return [cameras[0].ref, cameras[0].ref];

      return [cameras[index - 1].ref, cameras[0].ref];

    default:
      // Middle camera
      return [cameras[index - 1].ref, cameras[index + 1].ref];
  }
>>>>>>> d3747254e60 (Fixes camera console bluescreen (#78926))
};

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
const selectCameras = (cameras: Camera[], searchText = ''): Camera[] => {
  const testSearch = createSearch(searchText, (camera: Camera) => camera.name);

  return flow([
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
    filter((camera: Camera) => !!camera.name),
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy((camera: Camera) => camera),
  ])(cameras);
};

export const CameraConsole = (props) => {
=======
    // Null camera filter
    filter((camera: Camera) => !!camera?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy((camera: Camera) => camera.name),
  ])(cameras);
};

export const CameraConsole = (props, context) => {
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
  return (
    <Window width={850} height={708}>
      <Window.Content>
        <CameraContent />
      </Window.Content>
    </Window>
  );
};

<<<<<<< HEAD
export const CameraContent = (props) => {
=======
export const CameraContent = (props, context) => {
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
  return (
    <Stack fill>
      <Stack.Item grow>
        <CameraSelector />
      </Stack.Item>
      <Stack.Item grow={3}>
        <CameraControls />
      </Stack.Item>
    </Stack>
  );
};

<<<<<<< HEAD
const CameraSelector = (props) => {
  const { act, data } = useBackend<Data>();
  const [searchText, setSearchText] = useLocalState('searchText', '');
=======
const CameraSelector = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
  const { activeCamera } = data;
  const cameras = selectCameras(data.cameras, searchText);

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Input
          autoFocus
          fluid
          mt={1}
          placeholder="Search for a camera"
          onInput={(e, value) => setSearchText(value)}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {cameras.map((camera) => (
            // We're not using the component here because performance
            // would be absolutely abysmal (50+ ms for each re-render).
            <div
<<<<<<< HEAD
              key={camera.ref}
              title={camera.name}
              className={classes([
<<<<<<< HEAD
=======
              key={camera.name}
              title={camera.name}
              className={classes([
                'candystripe',
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
=======
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
                'Button',
                'Button--fluid',
                'Button--color--transparent',
                'Button--ellipsis',
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
                activeCamera?.ref === camera.ref
                  ? 'Button--selected'
                  : 'candystripe',
              ])}
              onClick={() =>
                act('switch_camera', {
                  camera: camera.ref,
                })
              }
            >
=======
                activeCamera &&
                  camera.name === activeCamera.name &&
                  'Button--selected',
              ])}
              onClick={() =>
                act('switch_camera', {
                  name: camera.name,
                })
              }>
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
              {camera.name}
            </div>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

<<<<<<< HEAD
const CameraControls = (props) => {
  const { act, data } = useBackend<Data>();
  const { activeCamera, can_spy, mapRef } = data;
  const [searchText] = useLocalState('searchText', '');

  const cameras = selectCameras(data.cameras, searchText);

  const [prevCamera, nextCamera] = prevNextCamera(cameras, activeCamera);
=======
const CameraControls = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { activeCamera, can_spy, mapRef } = data;
  const [searchText] = useLocalState(context, 'searchText', '');

  const cameras = selectCameras(data.cameras, searchText);

  const [prevCameraName, nextCameraName] = prevNextCamera(
    cameras,
    activeCamera
  );
>>>>>>> d1dde8c510d (Typescript camera console (#78412))

  return (
    <Section fill>
      <Stack fill vertical>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow>
<<<<<<< HEAD
<<<<<<< HEAD
              {activeCamera?.status ? (
=======
              {activeCamera?.name ? (
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
=======
              {activeCamera?.status ? (
>>>>>>> c4a57f76580 (Camera UI fixes (#78855))
                <NoticeBox info>{activeCamera.name}</NoticeBox>
              ) : (
                <NoticeBox danger>No input signal</NoticeBox>
              )}
            </Stack.Item>

            <Stack.Item>
              {!!can_spy && (
                <Button
                  icon="magnifying-glass"
                  tooltip="Track Person"
                  onClick={() => act('start_tracking')}
                />
              )}
            </Stack.Item>

            <Stack.Item>
              <Button
                icon="chevron-left"
<<<<<<< HEAD
                disabled={!prevCamera}
                onClick={() =>
                  act('switch_camera', {
                    camera: prevCamera,
=======
                disabled={!prevCameraName}
                onClick={() =>
                  act('switch_camera', {
                    name: prevCameraName,
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
                  })
                }
              />
            </Stack.Item>

            <Stack.Item>
              <Button
                icon="chevron-right"
<<<<<<< HEAD
                disabled={!nextCamera}
                onClick={() =>
                  act('switch_camera', {
                    camera: nextCamera,
=======
                disabled={!nextCameraName}
                onClick={() =>
                  act('switch_camera', {
                    name: nextCameraName,
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <ByondUi
            height="100%"
            width="100%"
            params={{
              id: mapRef,
              type: 'map',
            }}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
