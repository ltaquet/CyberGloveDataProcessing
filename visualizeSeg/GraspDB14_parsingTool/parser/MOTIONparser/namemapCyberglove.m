
function namemap = namemapCyberglove ( nsensors )
% Constructs a default name map for a CyberGlove sensor "arrangement"
%
% INPUT
%   nsensors ... number of sensors in the glove (valid values: 18 and 22)
%
% OUTPUT
%   namemap ... <23x2> cell array containing the sensor names (column 1)
%               and a second column indicating wether the sensor is active,
%               i.e. has in fact been measured (namemap{k,1}=1), or is
%               inactove, i.e. has been estimated from other joints or not
%               been implemented (namemap{k,1}=0)
%
% EXAMPLE
%   namemap = namemapCyberglove ( 18 )
%   namemap = namemapCyberglove ( 22 )
%

switch nsensors
case 18
	active = {1;1;1;1;1;1;0;0;1;1;0;1;1;1;0;1;1;1;0;1;1;1;1};
case 22
	active = {1;1;1;1;1;1;1;0;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1};
otherwise
	error ( ['Unknown type of CyberGlove with ', num2str(nsensors), ' sensors.'] );
end % of switch nsensors


namemap = {
    'T-TMCJ', %  1
    'T-MCPJ', %  2
    ...'T-IJ',   %  3
    'T-IPJ',   %  3
    'TI-AA',  %  4
    'I-MCPJ', %  5
    ...'I-PIJ',  %  6
    'I-PIPJ',  %  6
    ...'I-DIJ',  %  7 *
    'I-DIPJ',  %  7 *
    'I-AA',   %  8 **
    'M-MCPJ', %  9
    ...'M-PIJ',  % 10
    'M-PIPJ',  % 10
    ...'M-DIJ',  % 11 *
    'M-DIPJ',  % 11 *
    'MI-AA',  % 12
    'R-MCPJ', % 13
    ...'R-PIJ',  % 14
    'R-PIPJ',  % 14
    ...'R-DIJ',  % 15 *
    'R-DIPJ',  % 15 *
    'RM-AA',  % 16
    'L-MCPJ', % 17
    ...'L-PIJ',  % 18
    'L-PIPJ',  % 18
    ...'L-DIJ',  % 19 *
    'L-DIPJ',  % 19 *
    'LR-AA',  % 20
    'P-Arch', % 21
    'W-FE',   % 22
    'W-AA'    % 23
};

namemap = [namemap, active];

end % of function namemapCyberglove


% /**************************************************************************//**
%  *  \brief Create a CyberGlove name map
%  *
%  * Creates a CyberGlove name map
%  *
%  * cf. p.20 in the CyberGlove Reference Manual. Following table copied from
%  * that manual.
%  *
%  *  Byte Index | Sensor Name (Description)
%  * ------------+--------------------------------------------------------------
%  *       0.    | thumb rotation/TMJ (angle of thumb rotating across palm)
%  *       1.    | thumb MCPJ (joint where the thumb meets the palm)
%  *       2.    | thumb IPJ (outer thumb joint)
%  *       3.    | thumb abduction (angle between thumb and index finger)
%  *       4.    | index MCPJ (joint where the index meets the palm)
%  *       5.    | index PIPJ (joint second from finger tip)
%  *       6.*   | index DIPJ (joint closest to finger tip)
%  *       7.**  | index abduction (sideways motion of index finger)
%  *       8.    | middle MCPJ [Metacarpophalangeal joint, MCP joint]
%  *       9.    | middle PIPJ [Proximal interphalangeal joint, PIP joint]
%  *      10.*   | middle DIPJ [Distal interphalangeal joint, DIP joint]
%  *      11.    | middle-index abd'n (angle between middle and index fingers)
%  *      12.    | ring MCPJ
%  *      13.    | ring PIPJ
%  *      14.*   | ring DIPJ
%  *      15.    | ring-middle abduction (angle between ring and middle fingers)
%  *      16.    | pinkie MCPJ
%  *      17.    | pinkie PIPJ
%  *      18.*   | pinkie DIPJ
%  *      19.    | pinkie-ring abduction (angle between pinkie and ring finger)
%  *      20.    | palm arch (causes pinkie to rotate across palm)
%  *      21.    | wrist pitch (flexion/extension)
%  *      22.    | wrist yaw (abduction/adduction)
%  *      23.    | (not used)
%  *
%  *  *  = 22-sensor CyberGlove only
%  *  ** = Absolute abduction sensor not yet implemented. Refer to middle-index
%  *       relative abduction sensor.
%  *
%  *****************************************************************************/
