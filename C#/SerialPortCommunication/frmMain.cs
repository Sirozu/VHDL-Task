using System;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
namespace PCComm
{
    public partial class FrmMain : Form
    {

        private const int SHIFT = 2;
        private CommunicationManager comm = new CommunicationManager();
        //private string transType = string.Empty;
        public FrmMain()
        {
            InitializeComponent();
        }

        private void FrmMain_Load(object sender, EventArgs e)
        {
            LoadValues();
            SetDefaults();
            SetControlState();
        }

        private void CmdOpen_Click(object sender, EventArgs e)
        {
            comm.PortName = cboPort.Text;
            comm.Parity = cboParity.Text;
            comm.StopBits = cboStop.Text;
            comm.DataBits = cboData.Text;
            comm.BaudRate = cboBaud.Text;
            comm.DisplayWindow = rtbDisplay;
            comm.OpenPort();

            cmdOpen.Enabled = false;
            cmdClose.Enabled = true;
            cmdSend.Enabled = true;
        }

        /// <summary>
        /// Method to initialize serial port
        /// values to standard defaults
        /// </summary>
        private void SetDefaults()
        {
            cboPort.SelectedIndex = 0;
            cboBaud.SelectedText = "115200";
            cboParity.SelectedIndex = 0;
            cboStop.SelectedIndex = 1;
            cboData.SelectedIndex = 1;
        }

        /// <summary>
        /// methos to load our serial
        /// port option values
        /// </summary>
        private void LoadValues()
        {
            comm.SetPortNameValues(cboPort);
            comm.SetParityValues(cboParity);
            comm.SetStopBitValues(cboStop);
        }

        /// <summary>
        /// method to set the state of controls
        /// when the form first loads
        /// </summary>
        private void SetControlState()
        {
            rdoText.Checked = true;
            cmdSend.Enabled = false;
            cmdClose.Enabled = false;
        }

        private void CmdSend_Click(object sender, EventArgs e)
        {
            byte[] asciiBytes = Encoding.ASCII.GetBytes(txtSend.Text);
            Parallel.For(0, asciiBytes.Length, (i) => { asciiBytes[i] += SHIFT; });
            var encodeTextPlusASCII = System.Text.Encoding.ASCII.GetString(asciiBytes);

            byte checkSum = 0;
            foreach (var x in asciiBytes)
            {
                checkSum ^= x;
            }
            var checkSumASCII = System.Text.Encoding.ASCII.GetString(new byte[] { checkSum });

            comm.WriteData(encodeTextPlusASCII + checkSumASCII);
        }

        private void RdoHex_CheckedChanged(object sender, EventArgs e)
        {
            if (rdoHex.Checked == true)
            {
                comm.CurrentTransmissionType = PCComm.CommunicationManager.TransmissionType.Hex;
            }
            else
            {
                comm.CurrentTransmissionType = PCComm.CommunicationManager.TransmissionType.Text;
            }
        }

        private void CmdClose_Click(object sender, EventArgs e)
        {
            rtbDisplay.Text = "";
        }
    }
}