using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Xml;
namespace PASystem.API.Services
{
    public class GeneralService
    {

    }

    public class Googleapis
    {
        public Googleapis()
        {
        }
        //Properties
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string Address { get; set; }

        //The Geocoding here i.e getting the latt/long of address
        public void GeoCode()
        {
            //to Read the Stream
            StreamReader sr = null;

            //The Google Maps API Either return JSON or XML. We are using XML Here
            //Saving the url of the Google API 
            string url = String.Format("http://maps.googleapis.com/maps/api/geocode/xml?address=" +
            this.Address + "&sensor=false");

            //to Send the request to Web Client 
            WebClient wc = new WebClient();

            sr = new StreamReader(wc.OpenRead(url));



            XmlTextReader xmlReader = new XmlTextReader(sr);
            bool latread = false;
            bool longread = false;

            while (xmlReader.Read())
            {
                xmlReader.MoveToElement();
                switch (xmlReader.Name)
                {
                    case "lat":

                        if (!latread)
                        {
                            xmlReader.Read();
                            this.Latitude = xmlReader.Value.ToString();
                            latread = true;

                        }
                        break;
                    case "lng":
                        if (!longread)
                        {
                            xmlReader.Read();
                            this.Longitude = xmlReader.Value.ToString();
                            longread = true;
                        }

                        break;
                }
            }

        }

        
    }

    public static class ConvertDistance
    {
        public static double ConvertMilesToKilometers(double miles)
        {
            //
            // Multiply by this constant and return the result.
            //
            return miles * 1.609344;
        }

        public static double ConvertKilometersToMiles(double kilometers)
        {
            //
            // Multiply by this constant.
            //
            return kilometers * 0.621371192;
        }
    }
}