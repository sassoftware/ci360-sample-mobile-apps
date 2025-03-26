class JsonCreative {
  title: string;
  subTitle: string;
  bullets: string[];
  buttonText: string;
  spot: string;

  constructor(json: string | null) {
    try {
      const data = JSON.parse(json);
      if (!data) {
        this.title = '';
        this.subTitle = '';
        this.bullets = [];
        this.buttonText = '';
        this.spot = '';
      } else {
        this.title = data.title;
        this.subTitle = data.subTitle;
        this.bullets = data.bullets || [];
        this.buttonText = data.buttonText;
        this.spot = data.spot;
      }
    } catch (error) {
      console.log('JSON parse error: ', error);
      this.title = '';
      this.subTitle = '';
      this.bullets = [];
      this.buttonText = '';
      this.spot = '';
    }
  }
}

export default JsonCreative;
