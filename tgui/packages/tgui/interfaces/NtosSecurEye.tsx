import { NtosWindow } from '../layouts';
import { CameraContent } from './CameraConsole';

<<<<<<< HEAD
export const NtosSecurEye = (props) => {
=======
export const NtosSecurEye = (props, context) => {
>>>>>>> d1dde8c510d (Typescript camera console (#78412))
  return (
    <NtosWindow width={800} height={600}>
      <NtosWindow.Content>
        <CameraContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
