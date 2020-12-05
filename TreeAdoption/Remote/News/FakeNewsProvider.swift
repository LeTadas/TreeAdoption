import Combine
import Foundation

class FakeNewsProvider: NewsProvider {
    func getNews() -> AnyPublisher<Result<[NewsItem], RequestError>, Never> {
        return Just(
            Result.success(
                [
                    NewsItem(
                        id: "0",
                        createdAt: Date().advanced(by: 60 * 60),
                        title: "Sea Change: Why Long Records of Coastal Climate Matter",
                        content: """
                        Climate scientists will tell you a key challenge in studying climate change is the relative dearth of long-term monitoring sites around the world. The oldest continuously operating station — the Mauna Loa Observatory on Hawaii’s Big Island, which monitors carbon dioxide and other key constituents of our atmosphere that drive climate change — has only been in operation since the late 1950s.

                        This obstacle is even more profound in the world’s coastal areas. In the global open ocean, the international Argo program’s approximately 4,000 drifting floats have observed currents, temperature, salinity and other ocean conditions since the early 2000s. But near coastlines, the situation is different. While coastal weather stations are plentiful, their focus is to produce weather forecasts for commercial and recreational ocean users, which aren’t necessarily useful for studying climate. The relative lack of long-term records of surface and deep ocean conditions near coastlines has limited our ability to make accurate oceanographic forecasts.
                        """
                    ),
                    NewsItem(
                        id: "1",
                        createdAt: Date().advanced(by: 60 * 30),
                        title: "Fire and Ice: Why Volcanic Activity Is Not Melting the Polar Ice Sheets",
                        content: """
                        Few natural phenomena are as impressive or awesome to behold as glaciers and volcanoes. I’ve seen both with my own eyes. I’ve marveled at the enormous power of flowing ice as I trekked across a glacier on Washington’s Mount Rainier — an active, but dormant, volcano. And I’ve hiked a rugged lava field on Hawaii’s Big Island alone on a moonless night to witness the surreal majesty of a lava stream from Kilauea volcano spilling into the sea — its orange-red lava meeting the waves in billowing steam — while still more glowing ribbons of lava snaked down the mountain slopes behind me.

                        There are many places on Earth where fire meets ice. Volcanoes located in high-latitude regions are frequently snow- and ice-covered. In recent years, some have speculated that volcanic activity could be playing a role in the present-day loss of ice mass from Earth’s polar ice sheets in Greenland and Antarctica. But does the science support that idea?
                        """
                    ),
                    NewsItem(
                        id: "2",
                        createdAt: Date().advanced(by: 60 * 1),
                        title: "How Climate Change May Be Impacting Storms Over Earth's Tropical Oceans",
                        content: """
                        When NASA climate scientists speak in public, they’re often asked about possible connections between climate change and extreme weather events such as hurricanes, heavy downpours, floods, blizzards, heat waves and droughts. After all, it seems extreme weather is in the news almost every day of late, and people are taking notice. How might particular extreme weather and natural climate phenomena, such as El Niño and La Niña, be affected by climate change, they wonder?

                        There’s no easy answer, says Joao Teixeira, co-director of the Center for Climate Sciences at NASA’s Jet Propulsion Laboratory in Pasadena, California, and science team leader for the Atmospheric Infrared Sounder (AIRS) instrument on NASA’s Aqua satellite. “Within the scientific community it’s a relatively well-accepted fact that as global temperatures increase, extreme precipitation will very likely increase as well,” he says. “Beyond that, we’re still learning.”
                        """
                    ),
                    NewsItem(
                        id: "3",
                        createdAt: Date().advanced(by: 60 * 120),
                        title: "Why Milankovitch (Orbital) Cycles Can't Explain Earth's Current Warming",
                        content: """
                        In the last few months, a number of questions have come in asking if NASA has attributed Earth’s recent warming to changes in how Earth moves through space around the Sun: a series of orbital motions known as Milankovitch cycles.

                        What cycles, you ask?

                        Milankovitch cycles include the shape of Earth’s orbit (its eccentricity), the angle that Earth’s axis is tilted with respect to Earth’s orbital plane (its obliquity), and the direction that Earth’s spin axis is pointed (its precession). These cycles affect the amount of sunlight and therefore, energy, that Earth absorbs from the Sun. They provide a strong framework for understanding long-term changes in Earth’s climate, including the beginning and end of Ice Ages throughout Earth’s history. (You can learn more about Milankovitch cycles and the roles they play in Earth’s climate here).
                        """
                    )
                ]
            )
        ).eraseToAnyPublisher()
    }
}
