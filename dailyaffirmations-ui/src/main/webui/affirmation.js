export async function fetchAffirmation() {
    try {
        const response = await fetch('https://dailyaffirmations-dailyaffirmations.apps.cluster-dp64w.dp64w.sandbox3223.opentlc.com/affirmations', {
            headers: {
                'Origin': 'http://localhost:8088'
            }
        });
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const affirmation = await response.json();
        document.getElementById('affirmation').innerText = `${affirmation.text} - ${affirmation.author}`;
    } catch (error) {
        console.error('There was a problem with the fetch operation:', error);
    }
    document.getElementById('affirmation-button').addEventListener('click', () => fetchAnotherAffirmation());
}

async function fetchAnotherAffirmation() {
    try {
        const response = await fetch('http://localhost:8088/affirmations', {
            headers: {
                'Origin': 'http://localhost:8088'
            }
        });
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const affirmation = await response.json();
        document.getElementById('affirmation').innerText = `${affirmation.text} - ${affirmation.author}`;
    } catch (error) {
        console.error('There was a problem with the fetch operation:', error);
    }
}